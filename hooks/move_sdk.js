var fs = require('fs'), path = require('path');

module.exports = function(ctx) {
    rootdir = ctx.opts.projectRoot,
    android_dir = path.join(ctx.opts.projectRoot, 'platforms/android');
    //sdk_file = rootdir + '/build-extras.gradle';
    sdk_file = path.join(ctx.opts.projectRoot, 'platforms/android/app/libs/XperienceLib.aar');
    dest_sdk_folder = path.join(ctx.opts.projectRoot, 'platforms/android/libs');
    dest_sdk_file = path.join(ctx.opts.projectRoot, 'platforms/android/libs/XperienceLib.aar');

    ///*
    console.log("Before-Build Hook - rootdir", rootdir);
    console.log("Before-Build Hook - android_dir", android_dir);
    console.log("Before-Build Hook - sdk_file", sdk_file);
    console.log("Before-Build Hook - dest_sdk_file", dest_sdk_file);
    //*/

    if(!fs.existsSync(sdk_file)){
        console.log(sdk_file + ' not found. Skipping');
        return;
    }else if(!fs.existsSync(android_dir)){
        console.log(android_dir + ' not found. Skipping');
       return;
    }

    if (!fs.existsSync(dest_sdk_folder)){
        console.log("Creating libs folder...");
        fs.mkdirSync(dest_sdk_folder);
    }

    console.log('Copy ' + sdk_file + ' to ' + dest_sdk_folder);
    fs.createReadStream(sdk_file).pipe(fs.createWriteStream(dest_sdk_file));
}