# validate if the homestead name exists in vagrant lists of boxes
if [ $(vagrant global-status | grep -c "$HOMESTEAD_NAME") -eq "1" ]; then
    echo "\033[31m\nSorry, but $HOMESTEAD_NAME already exists!\n\033[0m";
    exit 1;
fi

# install homestead
cd $PROJECT_ROOT;
mkdir -p $PROJECT_ROOT/$PROJECT_NAME;
cd $PROJECT_ROOT/$PROJECT_NAME;
(mkdir $REPOSITORY_FOLDER);
composer require laravel/homestead --dev -vvv;
php vendor/bin/homestead make;

# copy raw files
cp $CREATOR_ROOT_DIR/raw/after.sh $PROJECT_ROOT/$PROJECT_NAME/after.sh;
cp $CREATOR_ROOT_DIR/raw/Homestead.yaml $PROJECT_ROOT/$PROJECT_NAME/Homestead.yaml;

# modify after.sh
sed -i -- "s/{name}/$GIT_NAME/g" after.sh;
sed -i -- "s/{email}/$GIT_EMAIL/g" after.sh;
rm "after.sh--";

# modify Homestead.yaml
sed -i -- "s/{GIT_FOLDER_NAME}/$GIT_FOLDER_NAME/g" Homestead.yaml;
sed -i -- "s/{PROJECT_URL}/$PROJECT_URL/g" Homestead.yaml;
sed -i -- "s/{REPOSITORY_FOLDER}/$REPOSITORY_FOLDER/g" Homestead.yaml;
sed -i -- "s/{HOMESTEAD_IP_ADDRESS}/$HOMESTEAD_IP_ADDRESS/g" Homestead.yaml;
sed -i -- "s/{DB_DATABASE}/$DB_DATABASE/g" Homestead.yaml;
sed -i -- "s/{HOMESTEAD_NAME}/$HOMESTEAD_NAME/g" Homestead.yaml;
sed -i -- "s/{HOMESTEAD_HOSTNAME}/$HOMESTEAD_HOSTNAME/g" Homestead.yaml;
rm "Homestead.yaml--";

# append 'brc' inside the aliases
echo "alias brc='git branch | grep \"* \"'" >> aliases;
