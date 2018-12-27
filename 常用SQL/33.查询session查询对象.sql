alter system dump datafile 311 block 1140;

SELECT b.Sid,
          Nvl(Substr(a.Object_Name, 1, 30),
              'P1=' || b.P1 || ' P2=' || b.P2 || ' P3=' || b.P3) Object_Name,
          a.Subobject_Name,
          a.Object_Type
     FROM Dba_Objects    a,
          V$session_Wait b,
          Sys.X$bh       c
    WHERE c.Obj = a.Object_Id(+)
      AND b.P1 = c.File#(+)
      AND b.P2 = c.Dbablk(+)
      AND b.Event = 'db file sequential read'
      AND b.sid   = 3090
   UNION
   SELECT b.Sid,
          Nvl(Substr(a.Object_Name, 1, 30),
              'P1=' || b.P1 || ' P2=' || b.P2 || ' P3=' || b.P3) Object_Name,
          a.Subobject_Name,
          a.Object_Type
     FROM Dba_Objects    a,
          V$session_Wait b,
          X$bh           c
    WHERE c.Obj = a.Data_Object_Id(+)
      AND b.P1 = c.File#(+)
      AND b.P2 = c.Dbablk(+)
      AND b.Event = 'db file sequential read'
      AND b.sid   = 3090
    ORDER BY 1;