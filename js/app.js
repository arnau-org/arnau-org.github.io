var element = document.getElementById("_any_");
if (element) {
	element.innerHTML = new Date().getFullYear();
} else {
	console.error("No s'ha trobat cap element amb l'ID '_any_'.");
}
