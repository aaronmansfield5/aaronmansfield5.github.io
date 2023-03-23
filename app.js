(async function () {
    const colours = {
        'JavaScript': '#f1e05a',
        'C#': '#178600'
    }
        
    fetch('https://api.github.com/users/aaronmansfield5/repos?sort=updated&direction=desc')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            Object.keys(data).forEach(key => {
                if(!data[key]) return false;
                if (data[key].name === data[key].owner.login || data[key].name.endsWith('.github.io')) return false;
                const repo = data[key]
                const repoData = {
                    url: repo.html_url,
                    name: repo.name,
                    description: repo.description,
                    coding: {
                        language: repo.language,
                        colour: colours[repo.language]
                    },
                    stars: {
                        url: repo.stargazers_url,
                        count: repo.stargazers_count
                    },
                    forks: {
                        url: repo.forks_url,
                        count: repo.forks_count
                    }
                }
                let newRepo = document.getElementsByClassName('git-repo-example')[0].cloneNode(true)
                newRepo.setAttribute('style', "visibility: visible; position: inherit;")
                newRepo.getElementsByClassName('repo-title')[0].innerHTML = repoData.name
                newRepo.getElementsByClassName('repo-desc')[0].innerHTML = repoData.description
                newRepo.getElementsByClassName('repo-code')[0].setAttribute('style', `fill: ${repoData.coding.colour};`)
                document.getElementsByClassName("repos")[0].append(newRepo)
            })

        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
})();
