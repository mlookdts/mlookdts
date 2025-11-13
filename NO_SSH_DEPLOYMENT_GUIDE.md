# 🚀 Hostinger FTP Deployment Guide (NO SSH Access)

This guide is specifically for deploying Laravel to Hostinger **without SSH access**, using only FTP and web-based tools.

## ✅ Pre-Upload Steps (Already Completed)

- [x] Build production assets (`npm run build`)
- [x] Install production dependencies (`composer install --no-dev`)
- [x] Update .htaccess for production
- [x] Create production .env template

## 📤 Step 1: Upload Files via FTP

### Upload ALL of these folders/files:

1. **app/** - Application code
2. **bootstrap/** - Bootstrap files
3. **config/** - Configuration files
4. **database/** - Migrations and seeders
5. **public/** - **IMPORTANT:** All contents including `build/` folder
6. **resources/** - Views and assets
7. **routes/** - Route definitions
8. **storage/** - Storage directory (must be writable)
9. **vendor/** - **MUST UPLOAD** (Composer dependencies)
10. **artisan** - Laravel command file
11. **composer.json** and **composer.lock**
12. **.htaccess** (from public folder)

### ❌ DO NOT Upload:
- `node_modules/`
- `.env` (create new on server)
- `.git/`
- `tests/` (optional)

### 📁 Directory Structure on Hostinger

**Option A: Laravel in public_html (Simplest)**
```
/home/u475920781/public_html/
├── app/
├── bootstrap/
├── config/
├── database/
├── public/          ← All contents of public/ folder go here
│   ├── index.php
│   ├── build/
│   ├── images/
│   └── .htaccess
├── resources/
├── routes/
├── storage/
├── vendor/
├── artisan
├── composer.json
└── .env
```

**Option B: Laravel outside public_html (More Secure)**
```
/home/u475920781/
├── dts/              ← Laravel root
│   ├── app/
│   ├── bootstrap/
│   ├── config/
│   ├── database/
│   ├── resources/
│   ├── routes/
│   ├── storage/
│   ├── vendor/
│   ├── artisan
│   ├── composer.json
│   └── .env
└── public_html/
    ├── index.php     ← Copy from dts/public/index.php
    ├── build/        ← Copy from dts/public/build/
    ├── images/       ← Copy from dts/public/images/
    └── .htaccess     ← Copy from dts/public/.htaccess
```

**If using Option B**, you need to edit `public_html/index.php`:
```php
require __DIR__.'/../dts/vendor/autoload.php';
$app = require_once __DIR__.'/../dts/bootstrap/app.php';
```

## 🔧 Step 2: Create .env File on Server

1. Connect via FTP (FileZilla)
2. Navigate to your Laravel root directory
3. Create a new file named `.env`
4. Copy contents from `env.production.template`
5. Make sure these are set correctly:
   ```
   APP_ENV=production
   APP_DEBUG=false
   APP_URL=https://dts4b.fusiontechph.com
   DB_HOST=srv490.hstgr.io
   DB_DATABASE=u475920781_dts4b
   DB_USERNAME=u475920781_dts4b
   DB_PASSWORD=dts4b.4321A
   ```

## 🔐 Step 3: Set File Permissions

Using FileZilla:
1. Right-click on `storage/` folder → File Attributes
2. Set to `775` (or `755` if 775 doesn't work)
3. Check "Recurse into subdirectories"
4. Apply to all files and directories
5. Repeat for `bootstrap/cache/` folder

**Alternative:** Use Hostinger's File Manager:
- Go to hPanel → File Manager
- Right-click folders → Change Permissions
- Set `storage/` and `bootstrap/cache/` to `775`

## 📦 Step 4: Create Storage Symlink (Manual Method)

Since you can't run `php artisan storage:link`, create it manually:

### Method 1: Using FileZilla (if supported)
1. In FileZilla, navigate to `public/` folder
2. Create a symbolic link named `storage`
3. Point it to `../storage/app/public`

### Method 2: Copy Files Instead (Easier)
1. Create folder: `public/storage/`
2. Copy contents from `storage/app/public/` to `public/storage/`
3. Update `config/filesystems.php` if needed

### Method 3: Use Helper Script (Recommended)
Upload the `run-artisan.php` script (see below) and run it via browser to create the symlink.

## 🗄️ Step 5: Database Setup

### Option A: Import via phpMyAdmin (Recommended)

1. **Export your local database:**
   - Open phpMyAdmin on your local machine
   - Select your database (`db_dts`)
   - Click "Export" tab
   - Choose "Quick" method, format: SQL
   - Click "Go" to download

2. **Import to Hostinger:**
   - Log into Hostinger hPanel
   - Go to phpMyAdmin
   - Select database `u475920781_dts4b`
   - Click "Import" tab
   - Choose the exported SQL file
   - Click "Go"

### Option B: Run Migrations via Web Script

1. Upload `run-artisan.php` (see below)
2. Access it via browser: `https://dts4b.fusiontechph.com/run-artisan.php?command=migrate`
3. **DELETE the script immediately after use for security!**

## 🛠️ Step 6: Run Artisan Commands (No SSH)

### Using run-artisan.php Helper Script

1. Upload `run-artisan.php` to your Laravel root directory
2. Access via browser: `https://dts4b.fusiontechph.com/run-artisan.php`
3. Run commands like:
   - `migrate` - Run database migrations
   - `storage:link` - Create storage symlink
   - `config:cache` - Cache configuration
   - `route:cache` - Cache routes
   - `view:cache` - Cache views

**⚠️ SECURITY WARNING:** 
- **DELETE `run-artisan.php` immediately after use!**
- This script gives full access to artisan commands
- Only use on a secure connection
- Remove it as soon as you're done

## 🧪 Step 7: Test Your Application

1. Visit: `https://dts4b.fusiontechph.com`
2. Check if the homepage loads
3. Test login functionality
4. Test file uploads (if applicable)
5. Check error logs: `storage/logs/laravel.log` (via FTP)

## 🔄 Step 8: Optimize (Optional)

If you uploaded `run-artisan.php`, you can cache for better performance:

1. Access: `https://dts4b.fusiontechph.com/run-artisan.php?command=config:cache`
2. Access: `https://dts4b.fusiontechph.com/run-artisan.php?command=route:cache`
3. Access: `https://dts4b.fusiontechph.com/run-artisan.php?command=view:cache`
4. **DELETE the script after use!**

## ⚠️ Important Notes

### Queue Workers
Since you can't run `php artisan queue:work` continuously:

1. **Option 1:** Set up cron job in Hostinger hPanel:
   - Go to Cron Jobs
   - Add: `* * * * * cd /home/u475920781/public_html && php artisan queue:work --once`
   - This runs queue worker once per minute

2. **Option 2:** Use scheduled tasks:
   - Laravel's scheduler can handle some queue processing
   - Set up cron: `* * * * * cd /path/to/project && php artisan schedule:run`

### Cron Jobs Setup in Hostinger
1. Log into hPanel
2. Go to "Cron Jobs"
3. Add new cron job:
   - **Command:** `cd /home/u475920781/public_html && php artisan schedule:run >> /dev/null 2>&1`
   - **Frequency:** Every minute (`* * * * *`)

### Reverb WebSocket
- **DISABLED** in production config (shared hosting doesn't support it)
- Real-time features won't work unless you use a third-party service like Pusher

## 🆘 Troubleshooting

### 500 Internal Server Error
1. Check `.env` file exists and is configured correctly
2. Check file permissions (`storage/` and `bootstrap/cache/` should be 775)
3. Check `storage/logs/laravel.log` for errors (download via FTP)
4. Temporarily set `APP_DEBUG=true` in `.env` to see errors (remember to change back!)

### Assets Not Loading
1. Verify `public/build/` folder was uploaded
2. Check browser console for 404 errors
3. Clear browser cache
4. Verify `APP_URL` in `.env` matches your domain

### Database Connection Error
1. Verify database credentials in `.env`
2. Check database exists in Hostinger phpMyAdmin
3. Verify database user has proper permissions
4. Check if database host is correct (`srv490.hstgr.io`)

### Permission Denied Errors
1. Set `storage/` to 775
2. Set `bootstrap/cache/` to 775
3. Ensure web server can write to these directories

## 📝 Quick Checklist

- [ ] All files uploaded via FTP
- [ ] `.env` file created with production settings
- [ ] File permissions set (storage/ and bootstrap/cache/ to 775)
- [ ] Database imported or migrations run
- [ ] Storage symlink created (or files copied)
- [ ] Test website loads correctly
- [ ] Test login functionality
- [ ] Test file uploads
- [ ] `run-artisan.php` deleted (if used)
- [ ] Cron jobs set up (if needed)

## 🎉 You're Done!

Your Laravel application should now be live at `https://dts4b.fusiontechph.com`

