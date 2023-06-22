SELECT name, url, location
    FROM steampipe_github.github_organization
    WHERE login = 'evidence-dev';