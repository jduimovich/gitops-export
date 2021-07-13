
mkdir _export
cd _export

curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/delete-unused-fields.sh >  delete-unused-fields.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/export-current-ns.sh >  export-current-ns.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/export-resources.sh >  export-resources.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/export-single-resource.sh >  export-single-resource.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/scrub-secrets.sh >  scrub-secrets.sh 
chmod +x *.sh

bash export-current-ns.sh

echo "Done Exporting "
echo $(pwd)
ls -al 
tree .

mv export ../export
cd ..
rm -rf _export 
rm kubeconfig.yaml 

 