var fs = require('fs'), path = require('path');

module.exports = function(context) {

    //const gradleProperties = path.join(context.opts.projectRoot, 'platforms/android/cordova/lib/builders/gradleProperties.js');
    const gradleProperties = path.join(context.opts.projectRoot, 'platforms/android/gradle.properties');
    
    if (fs.existsSync(gradleProperties)) {
     
      fs.readFile(gradleProperties, 'utf8', function (err,data) {
        
        if (err) {
          throw new Error('🚨 Unable to read gradle.properties: ' + err + ' 🚨');
        }
        var result = data;

        result = data.replace(/android.useAndroidX=false/g, "android.useAndroidX=true");
        result = result.replace(/android.enableJetifier=false/g, "android.enableJetifier=true");
        
        fs.writeFile(gradleProperties, result, 'utf8', function (err) {
          if (err) 
            {throw new Error('🚨 Unable to write to gradle.properties: ' + err + ' 🚨');}
          else 
            {console.log('✅ gradle.properties edited successfuly ✅');}
        });
      });
    } else {
        throw new Error("🚨 WARNING: gradle.properties was not found. The build phase may not finish successfuly 🚨");
    }
  }
