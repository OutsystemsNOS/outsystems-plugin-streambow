var fs = require('fs');
var path = require('path');

module.exports = function(context) {

    const projectRoot = context.opts.projectRoot;
    const manifestPath = path.join(projectRoot, 'platforms', 'android', 'app', 'src', 'main', 'AndroidManifest.xml');
        
        fs.readFile(manifestPath, {encoding: 'utf-8'}, function(err, data) {
            if (err) throw error;

            var newManifest = data.replace('android:name="androidx.core.content.FileProvider"', 'android:name="androidx.core.content.FileProvider" tools:replace="android:authorities"');
            newManifest = newManifest.replace('android:resource="@xml/file_viewer_paths"', 'android:resource="@xml/file_viewer_paths" tools:replace="android:resource"');

            fs.writeFile(manifestPath, newManifest, (err) => {
                if (err) throw err;
                console.log ('⭐️ AndroidManifest Successfully updated ⭐️');
            });

        });
}

