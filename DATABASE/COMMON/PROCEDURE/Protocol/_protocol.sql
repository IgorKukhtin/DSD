-- select min(Id), max(Id), min(OperDate), max(OperDate), max(Id) - min(Id), count(*) from movementProtocol_arc_arc
-- select min(Id), max(Id), min(OperDate), max(OperDate), max(Id) - min(Id), count(*)  from movementItemProtocol_arc_arc


INSERT INTO movementProtocol_arc_arc 
WITH tmp_ins AS (SELECT gpSelect.Id, gpSelect.movementid,  gpSelect.userid,   gpSelect.operdate,   gpSelect.protocoldata,  gpSelect.isinsert 
                                     
                                FROM dblink('host=192.168.0.213 dbname=project_a port=5432 user=admin password=vas6ok' :: Text
                                          , (' SELECT *'
                                          || ' FROM movementProtocol_arc_arc where Id between 267974159 + 1 + 200000000 and 267974159 + 300000000') :: Text
                                           ) AS gpSelect (id integer ,
                                                          movementid integer,
                                                          userid integer,
                                                          operdate tdatetime,
                                                          protocoldata tblob,
                                                          isinsert bOOLEAN
                                                         )
                               )
          SELECT tmp_ins.*
          FROM tmp_ins
  



INSERT INTO movementitemprotocol_arc_arc 
WITH tmp_ins AS (SELECT gpSelect.*
                                     
                                FROM dblink('host=192.168.0.213 dbname=project_a port=5432 user=admin password=vas6ok' :: Text
                                          , (' SELECT *'
                                          || ' FROM movementitemprotocol_arc_arc where Id between 335251657 + 1 + 180000000 and 335251657 + 280000000') :: Text
                                           ) AS gpSelect (id integer,
                                                          movementitemid integer,
                                                          userid integer,
                                                          operdate tdatetime,
                                                          protocoldata tblob,
                                                          isinsert boolean
                                                         )
                               )
          SELECT tmp_ins.*
          FROM tmp_ins