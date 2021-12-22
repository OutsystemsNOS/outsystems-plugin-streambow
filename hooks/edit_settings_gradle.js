var fs = require('fs'), path = require('path');

module.exports = function(context) {

    //const settingsGradle = path.join(context.opts.projectRoot, 'platforms/android/cordova/lib/builders/settingsGradle.js');
    const settingsGradle = path.join(context.opts.projectRoot, 'platforms/android/settings.gradle');
    
    if (fs.existsSync(settingsGradle)) {
     
      fs.readFile(settingsGradle, 'utf8', function (err,data) {
        
        if (err) {
          throw new Error('🚨 Unable to read settings.gradle.js: ' + err + ' 🚨');
        }
        var result = data;

        //result = data.replace(/\/\/ GENERATED FILE - DO NOT EDIT/g, "include \":app\", \":XperienceLib\"");
        result = data.replace(/include ":app"/g, "");
        result = result.replace(/\/\/ GENERATED FILE - DO NOT EDIT/g, "include \":app\", \":XperienceLib\"");
        
        fs.writeFile(settingsGradle, result, 'utf8', function (err) {
          if (err) 
            {throw new Error('🚨 Unable to write to settings.gradle.js: ' + err + ' 🚨');}
          else 
            {console.log('✅ settings.gradle.js edited successfuly ✅');}
        });
      });
    } else {
        throw new Error("🚨 WARNING: settings.gradle.js was not found. The build phase may not finish successfuly 🚨");
    }
  }
