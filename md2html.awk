#!/bin/awk
BEGIN{
	# used in line stack
	counter = 0;
	# used to count indent num
	item_enum_count=0;
	code_count = 0;
}

# indent or enumerate push
function ie_push(var){
	item_enum[item_enum_count] = var;
	item_enum_count++;
}

# indent or enumerate pop
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
	# replace [name](link) to <a href=link>name</a>
	var = gensub(/\[(.*)\].*\((.*)\)/,"<a href=\"\\2\">\\1</a>","g", var);
	return var;
}

function mathjax(var){
	# convert math expression
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
	# `` to <code> </code>
	if ( disable_code == "" ){
		while ( match(var, /`[^`]+`/) != 0 ){
			# first `
			sub("`","<code>", var);
			# second `
			sub("`","</code>", var);
		}
	}
	str = var
	ret_var = ""
	for(;;){
		#  -- <code> body <code> -- 
		num = index(str,"<code>");
		if ( num == 0 ){
			break;
		}
		# -- <code>
		Head = substr(str, 0, num+length("<code>")-1)
		# body <code> --
		str = substr(str, num+length("<code>"))
		num = index(str,"</code>")
		if ( num == 0 ){
			break;
		}
		# body
		Body = substr(str, 0, num-1)
		gsub("<","\\&lt;",Body)
		gsub(">","\\&gt;",Body)
		# </code> -- 
		Tail = substr(str, num)
		ret_var = ret_var Head Body 
		str = Tail
	}
	ret_var = ret_var str
	return ret_var
}

function inline_replace(var){
	# convert expression of link or mathjax or code if exists.
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
	# print "itemize in"
	print_stack("p");
	# print "print_stack end."
	indent_push(indent, "<ul>", "</ul>");
	# print "indent_push end"
	# print "LI ITEMIZE INLINE REPLACE CALLED"
	print "<li>" inline_replace(var);
	# print "inline_replace end"
	next;
}
function enumerate(indent, var){
	print_stack("p");
	indent_push(indent, "<ol>", "</ol>");
	print "<li>" inline_replace(var);
	next;
}

# if itemize mode is called
/^- /{
	# start from - means itemize
	# print "should access here" $0
	# print "$1 = " $1
	$1="";
	itemize(0, $0);
}
/^\t- /{
	$1="";
	itemize(1, $0);
}
# support only two nest now
/^\t\t- /{
	$1="";
	itemize(2, $0);
}

# if enumerate mode is called

/^[0-9]+\. /{
	$1="";
	enumerate(0, $0);
}

/^\t[0-9]+\. /{
	$1="";
	enumerate(1, $0);
}
# support only two nest now
/^\t\t[0-9]+\. /{
	$1="";
	enumerate(2, $0);
}

# ignore empty line
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
	push(inline_replace($0)"\n");
}
END{
	ie_pop_all();
	print_stack("p");
}
