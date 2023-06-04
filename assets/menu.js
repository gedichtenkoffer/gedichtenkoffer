window.addEventListener('resize', function () {
    const menu = document.querySelector('nav ul');
    if (window.innerWidth >= 800) {
        menu.style.display = 'block';
    }
});

const setupEventListeners = () => {
    document.querySelectorAll('.toggle-submenu').forEach((a) => {
        a.addEventListener('click', (e) => {
            e.preventDefault();
            const submenu = e.target.nextElementSibling;
            if (submenu) {
                submenu.classList.toggle('show');
                e.target.classList.toggle('active');
            }
        });
    });

    document.querySelector('nav h2').addEventListener('click', () => {
        const menu = document.querySelector('nav ul');
        if (window.innerWidth <= 800) {
            menu.style.display = menu.style.display == 'block' ? 'none' : 'block';
        }
    });
};

setupEventListeners();

const mainListOriginal = document.querySelector('nav ul').cloneNode(true);

const debounce = (func, wait) => {
    let timeout;

    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };

        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
};

const searchList = (searchTerm) => {
    const mainList = document.querySelector('nav ul');
    const listItems = mainList.getElementsByTagName('li');
    const formattedSearchTerm = searchTerm.toLowerCase().replace(/_/g, ' ');
    let results = new Set();

    for (let i = 0; i < listItems.length; i++) {
        const sublists = listItems[i].getElementsByTagName('ul');

        for (let j = 0; j < sublists.length; j++) {
            const sublistItems = sublists[j].getElementsByTagName('li');

            for (let k = 0; k < sublistItems.length; k++) {
                const formattedTextContent = sublistItems[k].textContent.toLowerCase().replace(/_/g, ' ');
                if (formattedTextContent.includes(formattedSearchTerm)) {
                    results.add(listItems[i]);
                }
            }
        }
    }

    return Array.from(results);
}

document.querySelector('nav input').addEventListener('input', debounce((e) => {
    const mainList = document.querySelector('nav ul');
    const searchTerm = document.querySelector('nav input').value;

    if (searchTerm === '') {
        const newMainList = mainListOriginal.cloneNode(true);
        mainList.parentNode.replaceChild(newMainList, mainList);
        setupEventListeners();
    } else {
        const results = searchList(searchTerm);

        if (results.length > 0) {
            const newMainList = document.createElement('ul');

            results.forEach(result => {
                const clonedResult = result.cloneNode(true);

                const submenus = clonedResult.getElementsByClassName('toggle-submenu');
                for (let i = 0; i < submenus.length; i++) {
                    submenus[i].classList.add('active');
                }

                const elements = clonedResult.getElementsByTagName('ul');
                for (let i = 0; i < elements.length; i++) {
                    elements[i].classList.add('show');
                }

                newMainList.appendChild(clonedResult);
            });

            mainList.parentNode.replaceChild(newMainList, mainList);
            setupEventListeners();
        } else {
            console.log('Search term "' + searchTerm + '" not found in any list item.');
        }
    }
}, 300));
