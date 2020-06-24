#!/bin/awk
BEGIN{
	counter = 0;
	item_enum_count=0;
	code_count = 0;
}


function ie_push(var){
	item_enum[item_enum_count] = var;
	item_enum_count++;
}
function ie_pop(){
	if ( counter < 0 ){
		return "";
	}
	item_enum_count--;
	return item_enum[item_enum_count];
}


function ie_pop_all(){
	c = item_enum_count;
	if ( c != 0 ){
		print "</li>";
	}
	for ( i=0; i<c; i++ ){
		print ie_pop();
	}
}
function push( var ){
	#print "push the var:" var "counter:" counter
	stack[counter] = var;
	counter++;
}
function pop(){
	if ( counter < 0 ){
		return "";
	}
	counter--;
	var = stack[counter];
	#print "pop the var: " var "counter: " counter
	return var;
}
function print_stack(with_p){
	if (counter == 0){
		return;
	}
	if ( with_p != "" && disable_p == "" ){
		print "<p>";
	}
	for( i=0; i<counter; i++ ){
		printf("%s",stack[i]);
	}
	if ( with_p != "" && disable_p == "" ){
		print "\n</p>"
	}
	counter = 0;
}

function link(var){
	var = gensub(/.*\[(.*)\].*\((.*)\).*/,"<a href=\"\\2\">\\1</a>","g", var);
	return var;
}

function mathjax(var){
	# why this do not convert <code>$@</code> help <code>$</code>?
	if ( disable_mathline == "" ){
		while ( match(var, /\$[^$]+\$/) != 0 ){
			sub("\\$","<span class=\"math inline\">\\(", var);
			sub("\\$","\\)</span>", var);
		}
	}
	return var
}

function code(var){
	if ( disable_code == "" ){
		while ( match(var, /`[^`]+`/) != 0 ){
			sub("`","<code>", var);
			sub("`","</code>", var);
		}
	}
	return var
}

function inline_replace(var){
	var = link(var)
	var = mathjax(var)
	var = code(var)
	return var
}
function html_print(var){
	if ( var != "" ){
		print var
	}
}

function head(num, var){
	print_stack("p");
	sub(/\n/,"",var);
	print("<h"num" id=\""var"\">"var"</h"num">");
	counter = 0;
	next;
}

/^```$/{
	print_stack();
	if (code_count == 0){
		code_count = 1;
		print "<pre><code>";
		disable_mathline="1";
		disable_code="1"
		disable_p="1"
	} else {
	code_count = 0;
	print_stack();
	print "</code></pre>";
	disable_mathline=""
	disable_code = ""
	disable_p=""
}
next;
}

/^[=]+$/{
	var = pop();
	head(1, var);
}
/^[-]+$/{
	var = pop();
	head(2, var);
}

function indent_push(i, before, after){
	if (item_enum_count -1 < i){
		print(before);
		ie_push(after);
	} else if(item_enum_count -1 > i){
	diff = item_enum_count - 1 -i;
	for ( i=0; i<diff; i++ ){
		print ie_pop() "</li>" ;
	}
} else {
print("</li>");
	}

}
function itemize(indent, var){
	print_stack("p");
	indent_push(indent, "<ul>", "</ul>");
	# print "LI ITEMIZE INLINE REPLACE CALLED"
	print "<li>" inline_replace(var);
	next;
}
function enumerate(indent, var){
	print_stack("p");
	indent_push(indent, "<ol>", "</ol>");
	print "<li>" inline_replace(var);
	next;
}
/^- /{
	$1="";
	itemize(0, $0);
}
/^\t- /{
	$1="";
	itemize(1, $0);
}
/^\t\t- /{
	$1="";
	itemize(2, $0);
}

/^[0-9]+\. /{
	$1="";
	enumerate(0, $0);
}
/^\t[0-9]+\. /{
	$1="";
	enumerate(1, $0);
}
/^\t\t[0-9]+\. /{
	$1="";
	enumerate(2, $0);
}

$0 == ""{
	ie_pop_all();
	print_stack("p");
	print "";
	next;
}
/^# /{
	if (disable_code  == "1"){
		push(inline_replace($0)"\n");
		next
	}
	$1="";
	head(1, $0);
}
/^## /{
	$1="";
	head(2, $0);
}
/^### /{
	$1="";
	head(3, $0);
}
/^#### /{
	$1="";
	head(4, $0);
}
/，$|．$/{
	push(inline_replace($0));
	next;
}
{

	gsub("<","\\&lt;",$0)
	gsub(">","\\&gt;",$0)
	push(inline_replace($0)"\n");
}
END{
	ie_pop_all();
	print_stack("p");
}
