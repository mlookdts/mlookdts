<?php
/**
 * Artisan & System Command Runner (Web Interface)
 * 
 * ⚠️ SECURITY WARNING: DELETE THIS FILE IMMEDIATELY AFTER USE!
 * This script allows running artisan commands and system commands via web browser.
 * Only use on secure connections and remove it as soon as you're done.
 * 
 * Usage: 
 * - Artisan: https://yourdomain.com/run-artisan.php?command=migrate
 * - System: https://yourdomain.com/run-artisan.php?command=composer:install
 */

// Security: Add a password or IP restriction
$ALLOWED_IP = ''; // Set your IP address here, or leave empty to disable IP check
$PASSWORD = 'your-secure-password-here'; // Change this to a secure password

// Check if exec() is available (required for running commands)
if (!function_exists('exec')) {
    die('<h2>Error: exec() function is disabled</h2><p>Your hosting provider has disabled the exec() function, which is required to run commands via this script.</p><p><strong>Solution:</strong> You need to run these commands locally and upload the results, or use SSH access if available.</p>');
}

// Check IP if set
if (!empty($ALLOWED_IP) && $_SERVER['REMOTE_ADDR'] !== $ALLOWED_IP) {
    die('Access denied. IP not allowed.');
}

// Check password if set
if (!empty($PASSWORD) && (!isset($_GET['password']) || $_GET['password'] !== $PASSWORD)) {
    die('Access denied. Invalid password. Add ?password=your-password to URL.');
}

// Get command from query string
$command = $_GET['command'] ?? 'list';

// Path to artisan (adjust if needed)
$artisanPath = __DIR__ . '/artisan';

// Allowed artisan commands (security measure - add only what you need)
$allowedArtisanCommands = [
    'migrate',
    'migrate:fresh',
    'migrate:refresh',
    'migrate:rollback',
    'db:seed',
    'storage:link',
    'config:cache',
    'config:clear',
    'route:cache',
    'route:clear',
    'view:cache',
    'view:clear',
    'cache:clear',
    'optimize:clear',
    'optimize',
    'key:generate',
    'reverb:start',
    'reverb:stop',
    'list',
];

// Allowed system commands (composer, npm, etc.)
$allowedSystemCommands = [
    'composer:install',
    'composer:update',
    'composer:dump-autoload',
    'npm:install',
    'npm:build',
    'npm:run',
];

// Parse command and arguments
$parts = explode(' ', $command);
$baseCommand = $parts[0];

// Check if it's a system command (format: tool:command)
$isSystemCommand = strpos($baseCommand, ':') !== false && !in_array($baseCommand, $allowedArtisanCommands);
$isArtisanCommand = in_array($baseCommand, $allowedArtisanCommands);

if (!$isArtisanCommand && !$isSystemCommand) {
    $allCommands = array_merge($allowedArtisanCommands, $allowedSystemCommands);
    die('Error: Command "' . $baseCommand . '" is not allowed. Allowed commands: ' . implode(', ', $allCommands));
}

// Validate system command
if ($isSystemCommand && !in_array($baseCommand, $allowedSystemCommands)) {
    die('Error: System command "' . $baseCommand . '" is not allowed. Allowed system commands: ' . implode(', ', $allowedSystemCommands));
}

// Check artisan file exists for artisan commands
if (!$isSystemCommand && !file_exists($artisanPath)) {
    die('Error: artisan file not found at ' . $artisanPath);
}

// Special handling for long-running commands
$isLongRunning = in_array($baseCommand, ['reverb:start']);

// Build full command based on type
if ($isSystemCommand) {
    // Handle system commands
    $systemParts = explode(':', $baseCommand);
    $tool = $systemParts[0];
    $action = $systemParts[1] ?? 'install';
    
    switch ($tool) {
        case 'composer':
            $fullCommand = 'composer ' . escapeshellcmd($action);
            if ($action === 'install') {
                $fullCommand .= ' --no-dev --optimize-autoloader';
            }
            $fullCommand .= ' 2>&1';
            $displayCommand = "composer {$action}";
            break;
            
        case 'npm':
            if ($action === 'run') {
                $npmCommand = $parts[1] ?? 'build';
                $fullCommand = 'npm run ' . escapeshellcmd($npmCommand) . ' 2>&1';
                $displayCommand = "npm run {$npmCommand}";
            } elseif ($action === 'build') {
                // npm:build runs "npm run build"
                $fullCommand = 'npm run build 2>&1';
                $displayCommand = "npm run build";
            } else {
                $fullCommand = 'npm ' . escapeshellcmd($action) . ' 2>&1';
                $displayCommand = "npm {$action}";
            }
            break;
            
        default:
            die('Error: Unknown system tool: ' . $tool);
    }
} else {
    // Handle artisan commands
    $fullCommand = 'php ' . escapeshellarg($artisanPath) . ' ' . escapeshellcmd($command) . ' 2>&1';
    $displayCommand = "php artisan {$command}";
}

// Execute command
echo "<h2>Running: {$displayCommand}</h2>";

// Warning for long-running commands
if ($isLongRunning) {
    echo "<div style='background: #fff3cd; border: 1px solid #ffc107; padding: 10px; margin: 10px 0; border-radius: 4px;'>";
    echo "<strong>⚠️ Warning:</strong> This is a long-running process. It may timeout via web interface.<br>";
    echo "Also note: Reverb WebSocket server requires SSH access and won't work on shared hosting like Hostinger.";
    echo "</div>";
}

// Warning for system commands that may take time
if ($isSystemCommand && in_array($baseCommand, ['composer:install', 'composer:update', 'npm:install', 'npm:build'])) {
    echo "<div style='background: #fff3cd; border: 1px solid #ffc107; padding: 10px; margin: 10px 0; border-radius: 4px;'>";
    echo "<strong>⚠️ Important Limitations on Shared Hosting:</strong><br>";
    echo "<ul style='margin: 5px 0; padding-left: 20px;'>";
    echo "<li><strong>Composer:</strong> May not be available or accessible via web. Many shared hosts disable exec().</li>";
    echo "<li><strong>NPM/Node.js:</strong> Rarely available on shared hosting. Usually not accessible via web.</li>";
    echo "<li><strong>Timeouts:</strong> These commands may timeout due to PHP execution limits.</li>";
    echo "</ul>";
    echo "<strong>Recommended:</strong> Run these commands locally and upload the <code>vendor/</code> and <code>node_modules/</code> folders via FTP.<br>";
    echo "Or build assets locally with <code>npm run build</code> and upload the <code>public/build/</code> folder.";
    echo "</div>";
}

echo "<pre>";
echo "Command: {$fullCommand}\n";
echo "---\n\n";

$output = [];
$returnCode = 0;

// Try to execute the command (2>&1 already included in $fullCommand)
$execResult = @exec($fullCommand, $output, $returnCode);

// If exec() returns false or empty, the command might not be available
if ($execResult === false && empty($output)) {
    echo "❌ <strong>Command execution failed!</strong>\n\n";
    echo "Possible reasons:\n";
    echo "1. The command/tool is not available on this server\n";
    echo "2. exec() function is restricted by hosting provider\n";
    echo "3. The tool is not in the system PATH\n";
    echo "4. Insufficient permissions to execute the command\n\n";
    
    if ($isSystemCommand) {
        $tool = explode(':', $baseCommand)[0];
        echo "<strong>For {$tool} commands on shared hosting:</strong>\n";
        if ($tool === 'composer') {
            echo "- Composer may not be installed or accessible\n";
            echo "- Try uploading vendor/ folder from your local machine instead\n";
        } elseif ($tool === 'npm') {
            echo "- Node.js/npm is rarely available on shared hosting\n";
            echo "- Build assets locally with 'npm run build' and upload public/build/\n";
        }
    }
} else {
    echo implode("\n", $output);
    
    if ($returnCode !== 0) {
        echo "\n\n❌ Error: Command returned exit code {$returnCode}";
        if ($isSystemCommand) {
            $tool = explode(':', $baseCommand)[0];
            echo "\n\n<strong>Tip:</strong> {$tool} may not be available on shared hosting.";
            echo " Consider running this locally and uploading the results.";
        }
    } else {
        echo "\n\n✓ Command executed successfully!";
    }
}

echo "</pre>";

// Show available commands
echo "<hr>";
echo "<h3>Available Artisan Commands:</h3>";
echo "<ul>";
foreach ($allowedArtisanCommands as $cmd) {
    echo "<li><a href='?command={$cmd}" . (!empty($PASSWORD) ? "&password={$PASSWORD}" : "") . "'>{$cmd}</a></li>";
}
echo "</ul>";

echo "<h3>Available System Commands:</h3>";
echo "<ul>";
foreach ($allowedSystemCommands as $cmd) {
    echo "<li><a href='?command={$cmd}" . (!empty($PASSWORD) ? "&password={$PASSWORD}" : "") . "'>{$cmd}</a></li>";
}
echo "</ul>";

echo "<hr>";
echo "<p style='color: red;'><strong>⚠️ REMEMBER TO DELETE THIS FILE AFTER USE!</strong></p>";
?>

