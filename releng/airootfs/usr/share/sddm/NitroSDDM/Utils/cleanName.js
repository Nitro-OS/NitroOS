function cleanName(name) {
    if (!name) {
        return "";
    }

    var value = name.toString();
    if (value.endsWith("/")) {
        value = value.substring(0, value.length - 1);
    }
    if (value.indexOf("/") !== -1) {
        value = value.substring(value.lastIndexOf("/") + 1);
    }
    if (value.indexOf(".desktop") !== -1) {
        value = value.substring(0, value.indexOf(".desktop"));
    }

    value = value.replace(/[-_]/g, " ");
    return value.charAt(0).toUpperCase() + value.slice(1);
}
