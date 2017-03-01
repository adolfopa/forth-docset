#! /usr/bin/awk -f

BEGIN {
    PATH_OFFSET = 33
    WORD_OFFSET = WORD_SET_OFFSET = 22

    PATH_RX = "<div class=\"wordNumber\"><a name=\"[^\"]+"
    WORD_RX = "<div class=\"wordName\">[^<]+"
    WORD_SET_RX = "<div class=\"wordList\">[^<]+"
}

$0 ~ PATH_RX {
    path = path_relative(extract($0, PATH_RX, PATH_OFFSET))
}

$0 ~ WORD_RX {
    word = unescape_xml(extract($0, WORD_RX, WORD_OFFSET))

    sql(word, "Word", path)
}

$0 ~ WORD_SET_RX {
    word_set = unescape_xml(extract($0, WORD_SET_RX, WORD_SET_OFFSET))

    word_set_paths[word_set] = path_relative()
}

END {
    for (word_set in word_set_paths)
        sql(word_set, "Module", word_set_paths[word_set])
}

function path_relative(path,    i) {
    i = index(FILENAME, "www.forth200x.org")

    return substr(FILENAME, i) (path ? "#" path : "")
}

function extract(s, rx, offset) {
    match(s, rx)

    return substr(s, RSTART + offset, RLENGTH - offset)
}

function sql(name, type, path) {
    printf("INSERT INTO searchIndex(name, type, path) VALUES ('%s', '%s', '%s');\n",
           escape_sql(name), escape_sql(type), escape_sql(path))
}

function escape_sql(s) {
    gsub(/'/, "''", s)

    return s
}

function unescape_xml(s) {
    gsub(/&gt;/, ">", s)
    gsub(/&lt;/, "<", s)
    gsub(/&quot;/, "\"", s)
    gsub(/&amp;/, "\\&", s)

    return s
}
