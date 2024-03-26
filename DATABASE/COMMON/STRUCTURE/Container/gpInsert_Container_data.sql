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


     RAISE INFO '���� : <%> and IsRecurse: <%> and inIsAll_container: <%> and inSRV_R: <%>' , inStartDate, inIsRecurse, inIsAll_container, inSRV_R;



     -- ��������
     vbVerId:= 1 + COALESCE ((SELECT MAX (VerId) FROM Container_data WHERE StartDate = inStartDate), 0);



     IF inSRV_R = TRUE
     THEN
         -- ���������
         vbScript:= 'INSERT INTO Container_data (StartDate, VerId
                                               , Id, DescId, ObjectId, Amount, Amount_data_real, ParentId
                                               , KeyValue, MasterKeyValue, ChildKeyValue, WhereObjectId
                                                )
                        -- �������
                        SELECT ' || CHR (39) || zfConvert_DateToString (inStartDate) ||  CHR (39) || ' :: TDateTime, ' || vbVerId :: TVarChar || '
                             , Container.Id
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
                        HAVING Container.Amount - COALESCE (SUM (COALESCE (MovementItemContainer.Amount, 0)), 0) <> 0
                    ';

         -- ������������
         RAISE INFO  '%',vbScript;

         -- ���������
         vb1:= (SELECT *
                FROM dblink_exec ('host=192.168.0.219 dbname=project port=5432 user=admin password=vas6ok'
                                   -- ���������
                                , vbScript));


         IF inIsAll_container = TRUE
         THEN
             -- ���������
             vbScript:= 'INSERT INTO Container_data (StartDate, VerId
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
                                                         AND Container_data.StartDate = ' || CHR (39) || zfConvert_DateToString (inStartDate) ||  CHR (39) || ' :: TDateTime
                                                         AND Container_data.VerId     = ' || vbVerId :: TVarChar || '
                            WHERE Container_data.Id IS NULL
                        ';

             -- ������������
             RAISE INFO  '%',vbScript;

             -- ���������
             vb2:= (SELECT *
                    FROM dblink_exec ('host=192.168.0.219 dbname=project port=5432 user=admin password=vas6ok'
                                       -- ���������
                                    , vbScript));

         END IF;

     ELSE
         IF inStartDate < '01.01.2023' AND EXISTS (SELECT 1 FROM Container_data WHERE StartDate = DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '1 YEAR')
         THEN
             -- 
             vbVerId_olap:= (SELECT MIN (Container_data.VerId) FROM Container_data WHERE Container_data.StartDate = DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '1 YEAR' AND Container_data.VerId > 0);

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

         END IF;


         IF inIsAll_container = TRUE
         THEN
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
                WHERE Container_data.Id IS NULL
               ;

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

-- ����
-- SELECT * FROM gpInsert_Container_data (inStartDate:= '01.02.2024', inIsRecurse:= FALSE, inIsAll_container:= TRUE,  inSRV_R:= TRUE,  inSession:= '5')
-- SELECT * FROM gpInsert_Container_data (inStartDate:= '01.02.2024', inIsRecurse:= FALSE, inIsAll_container:= FALSE, inSRV_R:= FALSE, inSession:= '5')
