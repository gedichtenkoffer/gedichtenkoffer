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

document.querySelector('nav input').addEventListener('input', debounce((e) => {
    const mainList = document.querySelector('nav ul');
    const searchTerm = document.querySelector('nav input').value;

    if (searchTerm === '') {
        const newMainList = mainListOriginal.cloneNode(true);
        mainList.parentNode.replaceChild(newMainList, mainList);
    } else {
        const result = searchList(searchTerm);

        if (result) {
            const newMainList = document.createElement('ul');
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
            mainList.parentNode.replaceChild(newMainList, mainList);
        } else {
            console.log('Search term not found in any list item.');
        }
    }
}, 300));

const searchList = (searchTerm) => {
    const mainList = document.querySelector('nav ul');
    const listItems = mainList.getElementsByTagName('li');
    const formattedSearchTerm = searchTerm.toLowerCase().replace(/_/g, ' ');

    for (let i = 0; i < listItems.length; i++) {
        const sublists = listItems[i].getElementsByTagName('ul');

        for (let j = 0; j < sublists.length; j++) {
            const sublistItems = sublists[j].getElementsByTagName('li');

            for (let k = 0; k < sublistItems.length; k++) {
                const formattedTextContent = sublistItems[k].textContent.toLowerCase().replace(/_/g, ' ');
                if (formattedTextContent.includes(formattedSearchTerm)) {
                    return listItems[i];
                }
            }
        }
    }

    return null;
}
