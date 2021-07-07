
mkdir _export
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/delete-unused-fields.sh > _export/delete-unused-fields.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/export-current-ns.sh > _export/export-current-ns.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/export-resources.sh > _export/export-resources.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/export-single-resource.sh > _export/export-single-resource.sh
curl https://raw.githubusercontent.com/jduimovich/gitops-export/main/scripts/scrub-secrets.sh > _export/scrub-secrets.sh 
chmod +x _export/*
bash _export/export-current-ns.sh

 