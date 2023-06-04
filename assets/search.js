const mainListOriginal = document.querySelector('nav ul').cloneNode(true);

document.querySelector('nav form').addEventListener('submit', function(e) {
    e.preventDefault(); // prevent the form from being submitted normally

    const mainList = document.querySelector('nav ul');
    const searchTerm = document.querySelector('nav form input').value;
    
    if (searchTerm === '') {
        // if search term is empty, restore original list
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
});

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
