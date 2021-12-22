var fs = require('fs'), path = require('path');

module.exports = function(ctx) {
    //var fs = ctx.require('fs'),
    //path = ctx.require('path'),
    rootdir = ctx.opts.projectRoot,
    android_dir = path.join(ctx.opts.projectRoot, 'platforms/android');
    gradle_file = rootdir + '/build-extras.gradle';
    dest_gradle_file = android_dir + '/build-extras.gradle';

    ///*
    console.log("Before-Build Hook - rootdir", rootdir);
    console.log("Before-Build Hook - android_dir", android_dir);
    console.log("Before-Build Hook - gradle_file", gradle_file);
    console.log("Before-Build Hook - dest_gradle_file", dest_gradle_file);
    //*/

    if(!fs.existsSync(gradle_file)){
        console.log(gradle_file + ' not found. Skipping');
        return;
    }else if(!fs.existsSync(android_dir)){
        console.log(android_dir + ' not found. Skipping');
       return;
    }

    console.log('Copy ' + gradle_file + ' to ' + android_dir);
    fs.createReadStream(gradle_file).pipe(fs.createWriteStream(dest_gradle_file));
}