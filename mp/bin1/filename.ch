@x (mf [38] m.774)
allows both lowercase and uppercase letters in the file name.
@^system dependencies@>

@d append_to_name(#)==begin c:=#; incr(k);
  if k<=file_name_size then name_of_file[k]:=xchr[c];
  end
@y
allows both lowercase and uppercase letters in the file name.
@^system dependencies@>

But |name_of_file| is of limited length and we must ensure both to not
overflow it but still to produce file names that are distinct, while the
prefix may be---for example for the job name---common. So we truncate
the prefix but never the extension that shall not be the empty string.

@d append_to_prefix(#)==begin c:=#; incr(k);
  if k<=(file_name_size-length(e)) then
    name_of_file[k]:=xchr[c];
  end
@d append_to_name(#)==begin c:=#; incr(k);
  if k<=file_name_size then name_of_file[k]:=xchr[c];
  end
@z
@x
for j:=str_start[a] to str_stop(a)-1 do append_to_name(so(str_pool[j]));
for j:=str_start[n] to str_stop(n)-1 do append_to_name(so(str_pool[j]));
@y
@!debug if e=0 then begin print_err("This can't happen!");
@.This can't happen@>
  help1("I'm broken. There shall always be an extension to filenames!");
  end;
gubed
for j:=str_start[a] to str_stop(a)-1 do append_to_prefix(so(str_pool[j]));
for j:=str_start[n] to str_stop(n)-1 do append_to_prefix(so(str_pool[j]));
@z
@x (mf [38] m.775)
@d mem_extension=".mem" {the extension, as a \.{WEB} constant}
@y
@d mem_extension=".mem" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".log" and "ps"}
@z
@x (mf [38] m.777)
@ @<Check the ``constant'' values for consistency@>=
if mem_default_length>file_name_size then bad:=20;
@y
@ The buffer |name_of_file| shall be able to accommodate for
|MP_mem_default|---that shall have a specific extension---but shall
too be able to hold the default job filename (\.{mpout.log}).

@d default_job_filenames_len=9 {"mpout.log"} 

@<Check the ``constant'' values for consistency@>=
if (mem_default_length>file_name_size)
  or(mem_ext_length<1)or(file_name_size<default_job_filenames_len)
  then bad:=20;
@z
