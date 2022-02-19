# myaskanswer
get all my answer from "https://ask.csdn.net" with plsql,and format to markdown table

### 安装步骤  
1. 将项目中的两个cer文件添加到你的oracle数据库的wallet里去
2. 打开sql文件,修改代码中的wallet路径,修改要获取数据的用户名,并保存
3. 将blog.csdn.net加入到acl
4. 执行sql文件

### 使用步骤
1. 执行MY_ASKANDANSWER_get_p刷新数据
```sql
begin  
MY_ASKANDANSWER_get_p;
end;
```

2. 查询数据获取情况
```sql
select * from MY_ASKANDANSWER;
```

3. 生成markdown格式化数据
```sql
select MY_ASKANDANSWER_format_f from dual;
```

### 效果
```
||
|-|
|**SOURCE**:CSDN_ASK|
|**ASK_ID**:7645884|
|**ANSWER_ID**:53693864|
|**TITLE**:SQL计算同指令下最晚完成时间及状态个数和完成情况。|
|**ANSWER**:<p>是什么数据库&#xff1f;版本多少&#xff1f;</p><br/><hr /><br/><p>只要是支持开窗函数的数据库,都可以用下面的方式来查询</p><br/><pre><code class="language-sql"><span class="hljs-keyword">select</span> t.*,<br/>last_value(完成日期) <span class="hljs-keyword">over</span>(<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令 <span class="hljs-keyword">order</span> <span class="hljs-keyword">by</span> 完成日期) 最晚完成时间,<br/><span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> (count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;V&#39;</span>,<span class="hljs-string">&#39;H&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令))&gt;<span class="hljs-number">0</span> <span class="hljs-keyword">THEN</span> <span class="hljs-string">&#39;未完成&#39;</span> <span class="hljs-keyword">else</span> <span class="hljs-string">&#39;完成&#39;</span> <span class="hljs-keyword">end</span> 完成状态,<br/>count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;B&#39;</span>,<span class="hljs-string">&#39;C&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令) BC个数,<br/>count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;A&#39;</span>,<span class="hljs-string">&#39;D&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令) AD个数,<br/>count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">NOT</span>  <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;A&#39;</span>,<span class="hljs-string">&#39;B&#39;</span>,<span class="hljs-string">&#39;C&#39;</span>,<span class="hljs-string">&#39;D&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令) 除ABCD个数<br/><span class="hljs-keyword">from</span> t<br/></code></pre><br/>|
|**LINK**:[https://ask.csdn.net/questions/7645884?answer=53693864](https://ask.csdn.net/questions/7645884?answer=53693864)|
```
||
|-|
|**SOURCE**:CSDN_ASK|
|**ASK_ID**:7645884|
|**ANSWER_ID**:53693864|
|**TITLE**:SQL计算同指令下最晚完成时间及状态个数和完成情况。|
|**ANSWER**:<p>是什么数据库&#xff1f;版本多少&#xff1f;</p><br/><hr /><br/><p>只要是支持开窗函数的数据库,都可以用下面的方式来查询</p><br/><pre><code class="language-sql"><span class="hljs-keyword">select</span> t.*,<br/>last_value(完成日期) <span class="hljs-keyword">over</span>(<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令 <span class="hljs-keyword">order</span> <span class="hljs-keyword">by</span> 完成日期) 最晚完成时间,<br/><span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> (count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;V&#39;</span>,<span class="hljs-string">&#39;H&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令))&gt;<span class="hljs-number">0</span> <span class="hljs-keyword">THEN</span> <span class="hljs-string">&#39;未完成&#39;</span> <span class="hljs-keyword">else</span> <span class="hljs-string">&#39;完成&#39;</span> <span class="hljs-keyword">end</span> 完成状态,<br/>count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;B&#39;</span>,<span class="hljs-string">&#39;C&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令) BC个数,<br/>count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;A&#39;</span>,<span class="hljs-string">&#39;D&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令) AD个数,<br/>count(<span class="hljs-keyword">case</span> <span class="hljs-keyword">when</span> 状态 <span class="hljs-keyword">NOT</span>  <span class="hljs-keyword">in</span> (<span class="hljs-string">&#39;A&#39;</span>,<span class="hljs-string">&#39;B&#39;</span>,<span class="hljs-string">&#39;C&#39;</span>,<span class="hljs-string">&#39;D&#39;</span>) <span class="hljs-keyword">THEN</span> <span class="hljs-number">1</span> <span class="hljs-keyword">END</span> ) <span class="hljs-keyword">OVER</span> (<span class="hljs-keyword">partition</span> <span class="hljs-keyword">by</span> 指令) 除ABCD个数<br/><span class="hljs-keyword">from</span> t<br/></code></pre><br/>|
|**LINK**:[https://ask.csdn.net/questions/7645884?answer=53693864](https://ask.csdn.net/questions/7645884?answer=53693864)|

