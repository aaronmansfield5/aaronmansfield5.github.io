(async function () {
    const colours = {
        'JavaScript': '#f1e05a',
        'C#': '#178600'
    }
        
    fetch('https://api.github.com/users/aaronmansfield5/repos?sort=added&direction=desc')
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
                    name: repo.name.replaceAll(/-(?!\d)/g, ' '),
                    description: repo.description.split(":")[0].replaceAll(/-(?!\d)/g, ' ') + ':' + repo.description.split(":")[1],
                    coding: {
                        language: repo.language,
                        colour: colours[repo.language]
                    },
                    stars: {
                        url: repo.stargazers_url.replace('api.', '').replace('/repos', ''),
                        count: repo.stargazers_count
                    },
                    forks: {
                        url: repo.forks_url.replace('api.', '').replace('/repos', ''),
                        count: repo.forks_count
                    }
                }
                let newRepo = document.getElementsByClassName('git-repo-example')[0].cloneNode(true)
                newRepo.setAttribute('style', "visibility: visible; position: inherit;")
                newRepo.getElementsByClassName('repo-title')[0].innerHTML = repoData.name
                newRepo.getElementsByClassName('repo-desc')[0].innerHTML = `${repoData.description}\n${repoData.url}`
                newRepo.getElementsByClassName('repo-lang')[0].innerHTML = repoData.coding.language
                newRepo.getElementsByClassName('repo-star-count')[0].innerHTML = repoData.stars.count
                newRepo.getElementsByClassName('repo-stars')[0].href = repoData.stars.url
                newRepo.getElementsByClassName('repo-fork-count')[0].innerHTML = repoData.forks.count
                newRepo.getElementsByClassName('repo-forks')[0].href = repoData.forks.url
                newRepo.getElementsByClassName('repo-code')[0].setAttribute('style', `fill: ${repoData.coding.colour};`)
                newRepo.getElementsByClassName('repo-url')[0].href = repoData.url
                document.getElementsByClassName("repos")[0].append(newRepo)
            })

        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
})();
