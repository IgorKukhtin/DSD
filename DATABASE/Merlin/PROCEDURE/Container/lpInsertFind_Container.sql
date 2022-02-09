-- Function: lpInsertFind_Container

DROP FUNCTION IF EXISTS lpInsertFind_Container (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Container(
    IN inContainerDescId         Integer  , -- DescId �������
    IN inParentId                Integer  , -- ������� Container
    IN inObjectId                Integer  , -- ������ (���� ��� ����� ��� ...)
    IN inJuridicalId_basis       Integer  , -- ������� ����������� ����
    IN inBusinessId              Integer  , -- �������
    IN inDescId_1                Integer  DEFAULT NULL , -- DescId ��� 1-�� ���������
    IN inObjectId_1              Integer  DEFAULT NULL , -- ObjectId ��� 1-�� ���������
    IN inDescId_2                Integer  DEFAULT NULL , -- DescId ��� 2-�� ���������
    IN inObjectId_2              Integer  DEFAULT NULL , -- ObjectId ��� 2-�� ���������
    IN inDescId_3                Integer  DEFAULT NULL , -- DescId ��� 3-�� ���������
    IN inObjectId_3              Integer  DEFAULT NULL , -- ObjectId ��� 3-�� ���������
    IN inDescId_4                Integer  DEFAULT NULL , -- DescId ��� 4-�� ���������
    IN inObjectId_4              Integer  DEFAULT NULL , -- ObjectId ��� 4-�� ���������
    IN inDescId_5                Integer  DEFAULT NULL , -- DescId ��� 5-�� ���������
    IN inObjectId_5              Integer  DEFAULT NULL , -- ObjectId ��� 5-�� ���������
    IN inDescId_6                Integer  DEFAULT NULL , -- DescId ��� 6-�� ���������
    IN inObjectId_6              Integer  DEFAULT NULL , -- ObjectId ��� 6-�� ���������
    IN inDescId_7                Integer  DEFAULT NULL , -- DescId ��� 7-�� ���������
    IN inObjectId_7              Integer  DEFAULT NULL , -- ObjectId ��� 7-�� ���������
    IN inDescId_8                Integer  DEFAULT NULL , -- DescId ��� 8-�� ���������
    IN inObjectId_8              Integer  DEFAULT NULL , -- ObjectId ��� 8-�� ���������
    IN inDescId_9                Integer  DEFAULT NULL , -- DescId ��� 9-�� ���������
    IN inObjectId_9              Integer  DEFAULT NULL , -- ObjectId ��� 9-�� ���������
    IN inDescId_10               Integer  DEFAULT NULL , -- DescId ��� 10-�� ���������
    IN inObjectId_10             Integer  DEFAULT NULL   -- ObjectId ��� 10-�� ���������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId   Integer;

   DECLARE vbWhereObjectId Integer;

   DECLARE vbKeyValue TVarChar;
   -- DECLARE vbMasterKeyValue BigInt;
   -- DECLARE vbChildKeyValue BigInt;

   DECLARE vbLock Integer;
   DECLARE vbSec Integer;
BEGIN
     -- ��� ��������� ��� � �� ���� ������: ���������� ����������������
     -- LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;


     --
     --
     inContainerDescId   := COALESCE (inContainerDescId, 0);
     inObjectId          := COALESCE (inObjectId, 0);
     inJuridicalId_basis := COALESCE (inJuridicalId_basis, 0);
     inBusinessId        := COALESCE (inBusinessId, 0);
     inObjectId_1        := COALESCE (inObjectId_1, 0);
     inObjectId_2        := COALESCE (inObjectId_2, 0);
     inObjectId_3        := COALESCE (inObjectId_3, 0);
     inObjectId_4        := COALESCE (inObjectId_4, 0);
     inObjectId_5        := COALESCE (inObjectId_5, 0);
     inObjectId_6        := COALESCE (inObjectId_6, 0);
     inObjectId_7        := COALESCE (inObjectId_7, 0);
     inObjectId_8        := COALESCE (inObjectId_8, 0);
     inObjectId_9        := COALESCE (inObjectId_9, 0);
     inObjectId_10       := COALESCE (inObjectId_10, 0);

     -- !!!
     -- !!!���� �� ������� � ���������� �� �������, ����� ����� �������, ������� ��������� �� ���� ��������� �� �����, �.�. �������� ��������!!!
     -- IF inObjectId <> zc_Enum_Account_100301() -- 100301; "������� �������� �������"
     -- THEN
     --     inBusinessId:= 0;
     -- END IF;
     -- !!!
     -- !!!


     -- !!!������������ ����!!!
     vbKeyValue = (SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                         FROM     (SELECT COALESCE (inContainerDescId, 0)         AS Value, 0 AS myOrder1, -1 AS myOrder2
                         UNION ALL SELECT COALESCE (inParentId, 0)                AS Value, 0 AS myOrder1, -2 AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId, 0)                AS Value, 0 AS myOrder1, -3 AS myOrder2

                         UNION ALL SELECT zc_ContainerLinkObject_JuridicalBasis() AS Value, 0 AS myOrder1, zc_ContainerLinkObject_JuridicalBasis() AS myOrder2
                         UNION ALL SELECT COALESCE (inJuridicalId_basis, 0)       AS Value, 1 AS myOrder1, zc_ContainerLinkObject_JuridicalBasis() AS myOrder2
                         UNION ALL SELECT zc_ContainerLinkObject_Business()       AS Value, 0 AS myOrder1, zc_ContainerLinkObject_Business() AS myOrder2
                         UNION ALL SELECT COALESCE (inBusinessId, 0)              AS Value, 1 AS myOrder1, zc_ContainerLinkObject_Business() AS myOrder2

                         UNION ALL SELECT COALESCE (inDescId_1, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_1, 1000000001)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_1, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_1, 1000000001)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_2, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_2, 1000000002)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_2, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_2, 1000000002)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_3, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_3, 1000000003)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_3, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_3, 1000000003)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_4, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_4, 1000000004)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_4, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_4, 1000000004)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_5, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_5, 1000000005)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_5, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_5, 1000000005)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_6, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_6, 1000000006)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_6, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_6, 1000000006)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_7, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_7, 1000000007)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_7, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_7, 1000000007)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_8, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_8, 1000000008)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_8, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_8, 1000000008)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_9, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_9, 1000000009)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_9, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_9, 1000000009)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_10, 0)   AS Value, 0 AS myOrder1, COALESCE (inDescId_10, 1000000010) AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_10, 0) AS Value, 1 AS myOrder1, COALESCE (inDescId_10, 1000000010) AS myOrder2
                                  ) AS tmp
                         ORDER BY tmp.myOrder2, tmp.myOrder1
                        ) AS tmp
                  );
     -- !!!������������ ��� ������ ����!!!
     -- vbMasterKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 1 FOR 8));
     -- !!!������������ ��� ������ ����!!!
     -- vbChildKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 9 FOR 8));


     BEGIN
          -- !!!������� ����� �� �����!!!
          vbContainerId := (SELECT Container.Id FROM Container WHERE Container.KeyValue = vbKeyValue);
          
          -- !!!������� ����� �� ���� ������!!!
          -- vbContainerId := (SELECT Container.Id FROM Container.Container WHERE Container.MasterKeyValue = vbMasterKeyValue AND Container.ChildKeyValue = vbChildKeyValue);
   
          EXCEPTION
                   WHEN invalid_row_count_in_limit_clause
                   THEN RAISE EXCEPTION '���� �� �������� : vbContainerId = <%>, inContainerDescId = <%>, inParentId = <%>, inObjectId = <%>, inJuridicalId_basis = <%>, inBusinessId = <%>, inDescId_1 = <%>, inObjectId_1 = <%>, inDescId_2 = <%>, inObjectId_2 = <%>, inDescId_3 = <%>, inObjectId_3 = <%>, inDescId_4 = <%>, inObjectId_4 = <%>, inDescId_5 = <%>, inObjectId_5 = <%>, inDescId_6 = <%>, inObjectId_6 = <%>, inDescId_7 = <%>, inObjectId_7 = <%>, inDescId_8 = <%>, inObjectId_8 = <%>, inDescId_9 = <%>, inObjectId_9 = <%>, inDescId_10 = <%>, inObjectId_10 = <%>'
                                      , vbContainerId, inContainerDescId, inParentId, inObjectId, inJuridicalId_basis, inBusinessId
                                      , inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
     END;


     -- ��� ������������ �������������� ���� (��� �����������)
     vbWhereObjectId:= (SELECT CASE WHEN inDescId_1 = zc_ContainerLinkObject_Unit() THEN inObjectId_1
                                    WHEN inDescId_2 = zc_ContainerLinkObject_Unit() THEN inObjectId_2
                                    WHEN inDescId_3 = zc_ContainerLinkObject_Unit() THEN inObjectId_3
                                    WHEN inDescId_4 = zc_ContainerLinkObject_Unit() THEN inObjectId_4
                                    WHEN inDescId_5 = zc_ContainerLinkObject_Unit() THEN inObjectId_5
                                    WHEN inDescId_6 = zc_ContainerLinkObject_Unit() THEN inObjectId_6
                                    WHEN inDescId_7 = zc_ContainerLinkObject_Unit() THEN inObjectId_7
                                    WHEN inDescId_8 = zc_ContainerLinkObject_Unit() THEN inObjectId_8
                                    WHEN inDescId_9 = zc_ContainerLinkObject_Unit() THEN inObjectId_9
                                    WHEN inDescId_10 = zc_ContainerLinkObject_Unit() THEN inObjectId_10
                               END);
     -- ��������
/*     IF COALESCE (vbWhereObjectId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��������� ��� ����������� WhereObjectId �� ����� ���� ������.';
     END IF;
*/
     -- ���� �� �����, ���������
     IF COALESCE (vbContainerId, 0) = 0
     THEN
         -- ��� ��������� ��� � �� ���� ������: ���������� ����������������
         IF zc_IsLockTable() = TRUE
         THEN
             -- LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
             LOCK TABLE LockProtocol IN SHARE UPDATE EXCLUSIVE MODE;
         END IF;

         -- �������� �������
         INSERT INTO Container (DescId, ObjectId, ParentId, Amount, KeyValue, WhereObjectId)
                        VALUES (inContainerDescId, inObjectId, CASE WHEN inParentId = 0 THEN NULL ELSE inParentId END, 0, vbKeyValue, vbWhereObjectId)
            RETURNING Id INTO vbContainerId;

         -- �������� ���������
         INSERT INTO ContainerLinkObject (DescId, ContainerId, ObjectId)
            SELECT zc_ContainerLinkObject_JuridicalBasis(), vbContainerId, inJuridicalId_basis WHERE inContainerDescId IN (zc_Container_Summ())
           UNION ALL
            SELECT zc_ContainerLinkObject_Business(), vbContainerId, inBusinessId WHERE inContainerDescId IN (zc_Container_Summ())
           UNION ALL
            SELECT inDescId_1, vbContainerId, inObjectId_1 WHERE inDescId_1 <> 0
           UNION ALL
            SELECT inDescId_2, vbContainerId, inObjectId_2 WHERE inDescId_2 <> 0
           UNION ALL
            SELECT inDescId_3, vbContainerId, inObjectId_3 WHERE inDescId_3 <> 0
           UNION ALL
            SELECT inDescId_4, vbContainerId, inObjectId_4 WHERE inDescId_4 <> 0
           UNION ALL
            SELECT inDescId_5, vbContainerId, inObjectId_5 WHERE inDescId_5 <> 0
           UNION ALL
            SELECT inDescId_6, vbContainerId, inObjectId_6 WHERE inDescId_6 <> 0
           UNION ALL
            SELECT inDescId_7, vbContainerId, inObjectId_7 WHERE inDescId_7 <> 0
           UNION ALL
            SELECT inDescId_8, vbContainerId, inObjectId_8 WHERE inDescId_8 <> 0
           UNION ALL
            SELECT inDescId_9, vbContainerId, inObjectId_9 WHERE inDescId_9 <> 0
           UNION ALL
            SELECT inDescId_10, vbContainerId, inObjectId_10 WHERE inDescId_10 <> 0;
     ELSE
         -- ��� ��������� ��� � �� ���� ������: ���������� ����������������
         IF zc_IsLockTable() = TRUE
         THEN
             -- LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
             LOCK TABLE LockProtocol IN SHARE UPDATE EXCLUSIVE MODE;
         ELSE
         IF zc_IsLockTableCycle() = TRUE
         THEN
             vbLock := 1;
             WHILE vbLock <> 0 LOOP
                 BEGIN
                    PERFORM Container.* FROM Container WHERE Container.Id = vbContainerId FOR UPDATE;
                    vbLock := 0;
                 EXCEPTION
                     WHEN OTHERS THEN vbLock := vbLock + 1;
                                      vbSec:= CASE WHEN 0 <> SUBSTR (vbContainerId :: TVarChar,  0 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbContainerId :: TVarChar,  0 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbContainerId :: TVarChar, -1 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbContainerId :: TVarChar, -1 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbContainerId :: TVarChar, -2 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbContainerId :: TVarChar, -2 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbContainerId :: TVarChar, -3 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbContainerId :: TVarChar, -3 + LENGTH (vbContainerId :: TVarChar), 1) :: Integer
                                                   ELSE SUBSTR (vbContainerId :: TVarChar, 1, 1) :: Integer
                                               END;
                                      --
                                      IF vbLock <= 5
                                      THEN PERFORM pg_sleep (zc_IsLockTableSecond());

                                      ELSE IF vbLock <= 10
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE IF vbLock <= 15
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE RAISE EXCEPTION 'Deadlock <%>', vbContainerId;
                                      END IF;
                                      END IF;
                                      END IF;
                 END;
             END LOOP;

         ELSE
             PERFORM Container.* FROM Container WHERE Container.Id = vbContainerId FOR UPDATE;
         END IF;
         END IF;

         -- update !!!only!! Parent
         UPDATE Container SET ParentId = CASE WHEN COALESCE (inParentId, 0) = 0 THEN NULL ELSE inParentId END
                              -- !!!�������� - ���� ������!!!
                            , WhereObjectId = vbWhereObjectId
         WHERE Id = vbContainerId AND COALESCE (ParentId, 0) <> COALESCE (inParentId, 0);

     END IF;


     -- ���������� ��������
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.06.17                                        * all
*/
/*
!!!CHECK Amount !!!
-- update container set Amount = a.AmountRemainsStart from (
SELECT Container.ObjectId AS AccountId
                      , Container.Id AS ContainerId
                      , Container.ParentId
                      , Container.Amount ,  COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
                 FROM Container
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.Containerid = Container.Id
--                 WHERE Container.DescId = 2
                 GROUP BY Container.ObjectId
                        , Container.Amount
                        , Container.Id
                        , Container.ParentId
                 HAVING (Container.Amount <> COALESCE (SUM (MIContainer.Amount), 0) )
) as a
where a. ContainerId = container.Id
*/

-- ����
-- SELECT * FROM lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()