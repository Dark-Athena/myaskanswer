create table MY_ASKANDANSWER
  (
    source      CHAR(8),
    ask_id      VARCHAR2(800),
    answer_id   VARCHAR2(800),
    title       VARCHAR2(200),
    content     CLOB,
    createtime  VARCHAR2(20),
    url         VARCHAR2(200),
    createtime2 DATE,
    show number(1)
  );


create or replace procedure MY_ASKANDANSWER_get_p is
  --DECLARE
  L_CLOB     bLOB;
  L_URL      VARCHAR2(200);
  l_username VARCHAR2(200);
  l_page     NUMBER;
  l_size     NUMBER;
  req        UTL_HTTP.REQ;
  resp       UTL_HTTP.RESP;
  value      raw(32767);
BEGIN

  l_username := 'wwwwwwgame';
  l_page     := 1;
  l_size     := 100;

  L_URL := 'https://blog.csdn.net/community/home-api/v1/get-business-list?page=l_page' ||
           chr(38) || 'size=' || l_size || chr(38) ||
           'businessType=askAnswer' || chr(38) || 'noMore=false' || chr(38) ||
           'username=' || l_username;

  delete MY_ASKANDANSWER where SOURCE = 'CSDN_ASK'; --清空数据
  utl_http.set_wallet(path => 'file:/u02/config/wallet'); --钱夹路径
  loop
    L_CLOB := empty_blob();
    dbms_lob.createtemporary(L_CLOB, true);
    /*declare
      pieces utl_http.html_pieces;
    begin
      pieces := utl_http.request_pieces(REPLACE(L_URL, 'l_page', l_page));
      for i in 1 .. pieces.count loop
        dbms_lob.append(dest_lob => L_CLOB, src_lob => pieces(i));
      end loop;
    end;*/--这个分页读取是按32767字节计算,如果最后一个字符是多字节字符的一半,会导致乱码,因此改为读raw二进制数据
    req := UTL_HTTP.BEGIN_REQUEST(REPLACE(L_URL, 'l_page', l_page),
                                  'GET',
                                  'HTTP/1.1');
    utl_http.set_header(req, 'Content-Type', 'application/json');
    resp := utl_http.get_response(req);
    begin
      LOOP
        UTL_HTTP.read_raw(resp, value, 32767);
        dbms_lob.append(dest_lob => L_CLOB, src_lob => value);
      END LOOP;
      utl_http.end_response(resp);
    EXCEPTION
      WHEN UTL_HTTP.END_OF_BODY THEN
        UTL_HTTP.END_RESPONSE(resp);
      WHEN OTHERS THEN
        UTL_HTTP.END_RESPONSE(resp);
    END;
    utl_http.close_persistent_conns;
    utl_tcp.close_all_connections;
    insert into MY_ASKANDANSWER
      (SOURCE,
       ASK_ID,
       ANSWER_ID,
       TITLE,
       CONTENT,
       CREATETIME,
       URL,
       CREATETIME2,
       show)
      select 'CSDN_ASK' SOURCE,
             REPLACE(SUBSTR(URL, 1, INSTR(URL, '?') - 1),
                     'https://ask.csdn.net/questions/') ASK_ID,
             SUBSTR(URL, INSTR(URL, '=') + 1) ANSWER_ID,
             p.title,
             content,
             createtime,
             url,
             rpad(createtime, 13, '0') / 86400000 + DATE '1970-01-01' + 8 / 24 createtime2,
             1
        from json_table(L_CLOB,
                        '$.data.list[*]'
                        columns(title varchar2(200) path '$.title',
                                content clob path '$.content',
                                createTime varchar2(20) path '$.createTime',
                                url varchar2(200) path '$.url')) p
       where URL is not null;
  
    if sql%notfound then
      exit;
    end if;
    --  DBMS_OUTPUT.put_line(dbms_lob.substr(L_CLOB,100,1));
    l_page := l_page + 1;
    DBMS_OUTPUT.put_line('第' || l_page || '页已插入');
    if l_page = 100 then
      DBMS_OUTPUT.put_line('超过100页,代码可能有异常,请确认没有问题后手动注销此判断');
      exit;
    end if;
  end loop;
  commit;
END;
/

create OR REPLACE function MY_ASKANDANSWER_format_f(l_ask_id number default null)
  return clob is
  l_clob clob;
begin
  L_CLOB := empty_clob();
  dbms_lob.createtemporary(L_CLOB, true);
  for rec in (select *
                from MY_ASKANDANSWER XX
               where ask_id = nvl(l_ask_id, ask_id)
                 and show = 1
               ORDER BY XX.CREATETIME2 DESC) loop
    dbms_lob.append(L_CLOB, '||' || chr(10));
    dbms_lob.append(L_CLOB, '|-|' || chr(10));
    dbms_lob.append(L_CLOB, '|**SOURCE**:' || rec.SOURCE || '|' || chr(10));
    dbms_lob.append(L_CLOB, '|**ASK_ID**:' || rec.ASK_ID || '|' || chr(10));
    dbms_lob.append(L_CLOB,'|**ANSWER_ID**:' || rec.ANSWER_ID || '|' || chr(10));
    dbms_lob.append(L_CLOB, '|**TITLE**:' || rec.TITLE || '|' || chr(10));
    dbms_lob.append(L_CLOB,'|**ANSWER**:' ||replace(replace(REGEXP_REPLACE(rec.CONTENT, chr(10), '<br/>'),'https://img-mid.csdnimg.cn','http://img-mid.csdnimg.cn'),'||','\|\|') || '|' ||chr(10));
    dbms_lob.append(L_CLOB,'|**LINK**:[' || REC.URL || '](' || REC.URL || ')|' ||chr(10));
    dbms_lob.append(L_CLOB, chr(10));
  end loop;
  RETURN L_CLOB;
end;
/

/*
--get data
begin 
    MY_ASKANDANSWER_get_p;
end;

select * from MY_ASKANDANSWER

--format
select MY_ASKANDANSWER_format_f from dual;
*/
