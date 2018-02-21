CREATOR_ROOT_DIR=$(pwd);

# load all constant configuration
source $CREATOR_ROOT_DIR/configuration.sh;

# install composer if does not exist
source $CREATOR_ROOT_DIR/installers/composer.sh;

# install the homestead
source $CREATOR_ROOT_DIR/installers/homestead.sh;

# install necessary tools inside the vagrant
(
    cd $PROJECT_ROOT/$PROJECT_NAME;
    vagrant up;
    vagrant reload --provision;

    # copy supervisord.conf
    cat $CREATOR_ROOT_DIR/raw/supervisord.conf | vagrant ssh -c "sudo cat - > /etc/supervisor/supervisord.conf"

    # initialize ssh (DO NOT REMOVE THIS)
    vagrant ssh -- -t "(
        cd ~/$REPOSITORY_FOLDER;
        git clone $GIT_REPOSITORY $GIT_FOLDER_NAME;
    );
    exit;
    /bin/sh";

    # update below if you need to add more commands
    vagrant ssh -- -t "(
        cd ~/$REPOSITORY_FOLDER;
        rm -rf $GIT_FOLDER_NAME;
        git clone $GIT_REPOSITORY $GIT_FOLDER_NAME;
        cd ~/$REPOSITORY_FOLDER/$GIT_FOLDER_NAME;
        cp .env.example .env;
        sed -i -- \"s/DB_DATABASE=homestead/DB_DATABASE=$DB_DATABASE/g\" .env;
        composer install;
        php artisan key:generate;
        php artisan migrate --force;
        php artisan db:seed --force;
    )
    exit;
    /bin/sh";
);

source $CREATOR_ROOT_DIR/installers/after-script.sh;

unset CREATOR_ROOT_DIR;
