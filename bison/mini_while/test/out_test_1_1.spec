
<SEQUENCE>
  <ASSIGN>
    <VAR:x>
    <INT:0>
  <SEQUENCE>
    <IF>
      <OP>
        <VAR:input>
        <INT:10>
      <IF>
        <OP>
          <VAR:input>
          <INT:5>
        <ASSIGN>
          <VAR:x>
          <INT:2>
        <ASSIGN>
          <VAR:x>
          <INT:3>
      <ASSIGN>
        <VAR:x>
        <INT:1>
    <ASSIGN>
      <VAR:result>
      <VAR:x>
result=2
