var fs = require('fs'), path = require('path');

module.exports = function(context) {

    const projectBuilder = path.join(context.opts.projectRoot, 'platforms/android/cordova/lib/builders/ProjectBuilder.js');
    
    if (fs.existsSync(projectBuilder)) {
     
      fs.readFile(projectBuilder, 'utf8', function (err,data) {
        
        if (err) {
          throw new Error('🚨 Unable to read ProjectBuilder.js: ' + err + ' 🚨');
        }
        var result = data;

        result = data.replace(/'\/\/ GENERATED FILE - DO NOT EDIT\n'/g, "include ':app', ':XperienceLib'");
        
        fs.writeFile(projectBuilder, result, 'utf8', function (err) {
          if (err) 
            {throw new Error('🚨 Unable to write to ProjectBuilder.js: ' + err + ' 🚨');}
          else 
            {console.log('✅ ProjectBuilder.js edited successfuly ✅');}
        });
      });
    } else {
        throw new Error("🚨 WARNING: ProjectBuilder.js was not found. The build phase may not finish successfuly 🚨");
    }
  }
