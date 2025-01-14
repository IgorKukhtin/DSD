-- Function: gpInsert_Container_data()

DROP FUNCTION IF EXISTS gpInsert_Container_data (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Container_data (TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Container_data (TDateTime, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Container_data(
    IN inStartDate           TDateTime , -- ���� ������
    IN inIsRecurse           Boolean   , --
    IN inIsAll_container     Boolean   , --
    IN inSRV_R               Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TEXT
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbVerId    Integer;
   DECLARE vbScript   TEXT;
   DECLARE vb1        TEXT;
   DECLARE vb2        TEXT;

   DECLARE vbVerId_olap Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());


     RAISE INFO '���� : <%> and IsRecurse = <%> and inIsAll_container = <%> and inSRV_R = <%>' , inStartDate, inIsRecurse, inIsAll_container, inSRV_R;
     RAISE INFO '<%>', CLOCK_TIMESTAMP();



     -- ��������
     vbVerId:= 1 + COALESCE ((SELECT MAX (VerId) FROM Container_data WHERE StartDate = inStartDate), 0);



     IF inSRV_R = TRUE
     THEN

         -- ��������� - ������� �� ������
         CREATE TEMP TABLE _tmpContainer_data (Id               Integer
                                             , DescId           Integer
                                             , ObjectId         Integer
                                             , Amount           TFloat
                                             , Amount_data_real TFloat
                                             , ParentId         Integer
                                             , KeyValue TVarChar, MasterKeyValue BigInt, ChildKeyValue BigInt, WhereObjectId Integer
                                              ) ON COMMIT DROP;

         -- ��������� - ������� �� ������
         INSERT INTO _tmpContainer_data (Id, DescId, ObjectId, Amount, Amount_data_real, ParentId
                                       , KeyValue, MasterKeyValue, ChildKeyValue, WhereObjectId
                                        )
            -- ���������
            SELECT tmpData.Id
                 , tmpData.DescId, tmpData.ObjectId
                 , tmpData.Amount
                 , tmpData.Amount_data_real
                 , tmpData.ParentId
                 , tmpData.KeyValue, tmpData.MasterKeyValue, tmpData.ChildKeyValue, tmpData.WhereObjectId
            FROM (WITH tmpData AS (SELECT gpSelect.Id
                                        , gpSelect.DescId, gpSelect.ObjectId
                                        , gpSelect.Amount
                                        , gpSelect.Amount_data_real
                                        , gpSelect.ParentId
                                        , gpSelect.KeyValue, gpSelect.MasterKeyValue, gpSelect.ChildKeyValue, gpSelect.WhereObjectId
                                   -- ����������� �� SRV-r
                                   FROM dblink('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL' :: Text
                                             , ('SELECT Container.Id
                                                      , Container.DescId, Container.ObjectId
                                                      , Container.Amount - COALESCE (SUM (COALESCE (MovementItemContainer.Amount, 0)), 0) AS Amount
                                                      , Container.Amount AS Amount_data_real
                                                      , Container.ParentId
                                                      , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId
                              
                                                 FROM Container
                                                      LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                     AND MovementItemContainer.OperDate    >= ' || CHR (39) || zfConvert_DateToString (inStartDate) ||  CHR (39) || ' :: TDateTime
                                                 GROUP BY Container.Id
                                                        , Container.DescId, Container.ObjectId
                                                        , Container.Amount
                                                        , Container.ParentId
                                                        , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId
                                                 HAVING Container.Amount - COALESCE (SUM (COALESCE (MovementItemContainer.Amount, 0)), 0) <> 0'
                                               ) :: Text
                                              ) AS gpSelect (Id               Integer
                                                           , DescId           Integer
                                                           , ObjectId         Integer
                                                           , Amount           TFloat
                                                           , Amount_data_real TFloat
                                                           , ParentId         Integer
                                                           , KeyValue TVarChar, MasterKeyValue BigInt, ChildKeyValue BigInt, WhereObjectId Integer
                                                            )
                                  )
                  -- ���������
                  SELECT *
                  FROM tmpData
                 ) AS tmpData
                ;

         -- ������������
         RAISE INFO  'end insert - 1 - <%>  <%>', (SELECT COUNT(*) FROM _tmpContainer_data), CLOCK_TIMESTAMP();


         IF inIsAll_container = TRUE
         THEN
             -- ��������� - ���� ������, �� �������
             CREATE TEMP TABLE _tmpContainer_del (Id Integer) ON COMMIT DROP;
             -- ��������� - ���� ������, �� �������
             INSERT INTO _tmpContainer_del (Id)
                -- ���������
                SELECT tmpData.Id
                FROM (WITH tmpData AS (SELECT gpSelect.Id
                                       -- ����������� �� SRV-r
                                       FROM dblink('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL' :: Text
                                                 , ('SELECT Container.Id
                                                     FROM Container
                                                          LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                         AND MovementItemContainer.OperDate    <' || CHR (39) || zfConvert_DateToString (inStartDate) ||  CHR (39) || ' :: TDateTime
                                                     WHERE MovementItemContainer.ContainerId IS NULL'
                                                   ) :: Text
                                                  ) AS gpSelect (Id               Integer
                                                                )
                                      )
                      -- ���������
                      SELECT *
                      FROM tmpData
                     ) AS tmpData
                    ;
    
             -- ������������
             RAISE INFO  'end insert - 2 - <%>  <%>', (SELECT COUNT(*) FROM _tmpContainer_del), CLOCK_TIMESTAMP();

             -- ���������
             INSERT INTO _tmpContainer_data (Id, DescId, ObjectId, Amount, Amount_data_real, ParentId
                                           , KeyValue, MasterKeyValue, ChildKeyValue, WhereObjectId
                                            )
                            -- �������
                            SELECT Container.Id
                                 , Container.DescId, Container.ObjectId
                                 , 0 AS Amount
                                 , Container.Amount AS Amount_data_real
                                 , Container.ParentId
                                 , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId

                            FROM Container
                                 LEFT JOIN _tmpContainer_data ON _tmpContainer_data.Id = Container.Id
                                 -- LEFT JOIN _tmpContainer_del  ON _tmpContainer_del.Id  = Container.Id
                            WHERE _tmpContainer_data.Id IS NULL
                            --AND _tmpContainer_del.Id IS NULL
                        ;

             -- ������������
             -- RAISE INFO  '%',vbScript;
             RAISE INFO  'end insert - 3 - <%>  <%>', (SELECT COUNT(*) FROM _tmpContainer_data), CLOCK_TIMESTAMP();

             -- ���������
             /*vb2:= (SELECT *
                    FROM dblink_exec ('host=192.168.0.219 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'
                                       -- ���������
                                    , vbScript));*/

         END IF;


         -- ��������� - ������� �� ������
         INSERT INTO Container_data (StartDate, VerId
                                   , Id, DescId, ObjectId, Amount, Amount_data_real, ParentId
                                   , KeyValue, MasterKeyValue, ChildKeyValue, WhereObjectId
                                    )
            SELECT inStartDate, vbVerId
                 , tmpData.Id
                 , tmpData.DescId, tmpData.ObjectId
                 , tmpData.Amount
                 , tmpData.Amount_data_real
                 , tmpData.ParentId
                 , tmpData.KeyValue, tmpData.MasterKeyValue, tmpData.ChildKeyValue, tmpData.WhereObjectId
            FROM _tmpContainer_data AS tmpData
           ;

         --
         RAISE INFO  'end insert - all   <%>', CLOCK_TIMESTAMP();


     ELSE
         -- !!!��� ������� �������!!!
         IF inStartDate < '01.01.2023' AND EXISTS (SELECT 1 FROM Container_data WHERE StartDate = DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '1 YEAR')
         THEN
             --  ������� �� ������������� ����(!!!�� �������!!!) - �����
             vbVerId_olap:= (SELECT MAX (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '1 YEAR' AND Container_data.VerId > 0);

             -- ���������
             INSERT INTO Container_data (StartDate, VerId
                                       , Id, DescId, ObjectId, Amount, Amount_data_real, ParentId
                                       , KeyValue, MasterKeyValue, ChildKeyValue, WhereObjectId
                                        )
                -- �������
                SELECT inStartDate, vbVerId
                     , Container.Id
                     , Container.DescId, Container.ObjectId
                     , Container.Amount - COALESCE (SUM (COALESCE (MovementItemContainer.Amount, 0)), 0) AS Amount
                     , Container.Amount AS Amount_data_real
                     , Container.ParentId
                     , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId
    
                FROM Container_data AS Container
                     LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                    AND MovementItemContainer.OperDate    >= inStartDate
                                                    AND MovementItemContainer.OperDate    < DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '1 YEAR'
                WHERE -- ���������� !!!OLAP!!!
                      Container.StartDate = DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '1 YEAR'
                  AND Container.VerId     = vbVerId_olap

                GROUP BY Container.Id
                       , Container.DescId, Container.ObjectId
                       , Container.Amount
                       , Container.ParentId
                       , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId

                HAVING Container.Amount - COALESCE (SUM (COALESCE (MovementItemContainer.Amount, 0)), 0) <> 0
               ;

         ELSE
             -- ��������� - ������� �� ������
             INSERT INTO Container_data (StartDate, VerId
                                       , Id, DescId, ObjectId, Amount, Amount_data_real, ParentId
                                       , KeyValue, MasterKeyValue, ChildKeyValue, WhereObjectId
                                        )
                -- �������
                SELECT inStartDate, vbVerId
                     , Container.Id
                     , Container.DescId, Container.ObjectId
                     , Container.Amount - COALESCE (SUM (COALESCE (MovementItemContainer.Amount, 0)), 0) AS Amount
                     , Container.Amount AS Amount_data_real
                     , Container.ParentId
                     , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId
    
                FROM Container
                     LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                    AND MovementItemContainer.OperDate    >= inStartDate
                GROUP BY Container.Id
                       , Container.DescId, Container.ObjectId
                       , Container.Amount
                       , Container.ParentId
                       , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId
                HAVING Container.Amount - COALESCE (SUM (COALESCE (MovementItemContainer.Amount, 0)), 0) <> 0
                  --!!!!OR Container.Amount <> 0
                  -- OR inIsAll_container = TRUE
               ;

             -- ������������
             RAISE INFO  'end insert - 1 - <%>', CLOCK_TIMESTAMP();

         END IF;


         IF inIsAll_container = TRUE
         THEN
             -- ��������� - ���� ������, �� �������
             CREATE TEMP TABLE _tmpContainer_del (Id Integer) ON COMMIT DROP;
             -- ��������� - ���� ������, �� �������
             INSERT INTO _tmpContainer_del (Id)
                -- ���������
                SELECT Container.Id
                FROM Container
                     LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                    AND MovementItemContainer.OperDate    < inStartDate
                WHERE MovementItemContainer.ContainerId IS NULL
               ;

             -- ������������
             RAISE INFO  'end insert - 2 - <%>  <%>', (SELECT COUNT(*) FROM _tmpContainer_del), CLOCK_TIMESTAMP();


             INSERT INTO Container_data (StartDate, VerId
                                       , Id, DescId, ObjectId, Amount, Amount_data_real, ParentId
                                       , KeyValue, MasterKeyValue, ChildKeyValue, WhereObjectId
                                        )
                -- �������
                SELECT inStartDate, vbVerId
                     , Container.Id
                     , Container.DescId, Container.ObjectId
                     , 0 AS Amount
                     , Container.Amount AS Amount_data_real
                     , Container.ParentId
                     , Container.KeyValue, Container.MasterKeyValue, Container.ChildKeyValue, Container.WhereObjectId

                FROM Container
                     LEFT JOIN Container_data ON Container_data.Id        = Container.Id
                                             AND Container_data.StartDate = inStartDate
                                             AND Container_data.VerId     = vbVerId
                     -- LEFT JOIN _tmpContainer_del  ON _tmpContainer_del.Id  = Container.Id
                WHERE Container_data.Id IS NULL
                --AND _tmpContainer_del.Id IS NULL
               ;


             -- ������������
              RAISE INFO  'end insert - all   <%>', CLOCK_TIMESTAMP();

         END IF;

     END IF;

     RETURN vb1 :: Text || ' * ' || COALESCE (vb2, '');


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.01.24         *
*/

/*
WITH tmpAll+_
SELECT
FROM

*/
-- DELETE FROM Container_data WHERE StartDate = '01.12.2024' AND VerId = 3
-- ����
-- SELECT * FROM gpInsert_Container_data (inStartDate:= '01.02.2024', inIsRecurse:= FALSE, inIsAll_container:= TRUE,  inSRV_R:= TRUE,  inSession:= '5')
-- SELECT * FROM gpInsert_Container_data (inStartDate:= '01.02.2024', inIsRecurse:= FALSE, inIsAll_container:= FALSE, inSRV_R:= FALSE, inSession:= '5')
-- SELECT * FROM gpInsert_Container_data (inStartDate:= '01.12.2024', inIsRecurse:= FALSE, inIsAll_container:= FALSE, inSRV_R:= FALSE, inSession:= '5')
