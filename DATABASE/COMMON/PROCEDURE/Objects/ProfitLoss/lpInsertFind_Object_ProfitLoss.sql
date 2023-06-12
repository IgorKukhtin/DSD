-- Function: lpInsertFind_Object_ProfitLoss (Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_ProfitLoss (Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ProfitLoss(
    IN inProfitLossGroupId      Integer  , -- ������ ����
    IN inProfitLossDirectionId  Integer  , -- ��������� ���� - �����������
    IN inInfoMoneyDestinationId Integer  , -- �������������� ����������
    IN inInfoMoneyId            Integer  , -- ������ ����������
    IN inInsert                 Boolean  DEFAULT FALSE , --
    IN inUserId                 Integer  DEFAULT NULL   -- ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbProfitLossDirectionId Integer;
   DECLARE vbProfitLossDirectionCode Integer;
   DECLARE vbProfitLossDirectionName TVarChar;
   DECLARE vbProfitLossId Integer;
   DECLARE vbProfitLossCode Integer;
   DECLARE vbProfitLossName TVarChar;
BEGIN

   -- ����� - ���������� ��������
   IF (COALESCE (inProfitLossGroupId, 0) = 0 OR COALESCE (inProfitLossDirectionId, 0) = 0)
      AND 1 = (SELECT  COUNT(*) FROM ObjectLink AS OL_InfoMoney WHERE OL_InfoMoney.ChildObjectId = inInfoMoneyId AND OL_InfoMoney.DescId = zc_ObjectLink_ProfitLoss_InfoMoney())
   THEN
       RETURN (SELECT OL_InfoMoney.ObjectId
               FROM ObjectLink AS OL_InfoMoney
               WHERE OL_InfoMoney.ChildObjectId = inInfoMoneyId
                 AND OL_InfoMoney.DescId        = zc_ObjectLink_ProfitLoss_InfoMoney()
              );
   END IF;

   -- ��������
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ������������ : <%>, <%>, <%>, <%>', inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId, lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId);
   END IF;

   IF COALESCE (inProfitLossGroupId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ������ ���� �.�. �� ����������� <������ ����> : <%>, <%>, <%>, <%>', inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inProfitLossDirectionId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ������ ���� �.�. �� ����������� <��������� ���� - �����������> : <%>, <%>, <%>, <%>', lfGet_Object_ValueData_sh (inProfitLossGroupId), lfGet_Object_ValueData_sh (inProfitLossDirectionId), lfGet_Object_ValueData_sh (inInfoMoneyDestinationId), lfGet_Object_ValueData_sh (inInfoMoneyId);
   END IF;

   IF COALESCE (inInfoMoneyDestinationId, 0) = 0 AND COALESCE (inInfoMoneyId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ������ ���� �.�. �� ����������� <�������������� ����������> : <%>, <%>, <%>, <%>', inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;


   -- �������.1 - ������� ������ ���� �� <�������������� ����������> ��� <������ ����������>
   IF inInfoMoneyDestinationId <> 0 THEN vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyDestinationId);
                                    ELSE vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoney (inProfitLossGroupId, inProfitLossDirectionId, inInfoMoneyId);
   END IF;
   -- �������.2 (���� �� �����) - ������ (10200)������ ����� -> (20600)������ ��������� � ������� ������ ���� �� <�������������� ����������>
   IF COALESCE (vbProfitLossId, 0) = 0 AND inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()
   THEN vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, inProfitLossDirectionId, zc_Enum_InfoMoneyDestination_20600());
   END IF;


   -- �������� - ������ �� ������ ���� �������
   IF EXISTS (SELECT Id FROM Object WHERE Id = vbProfitLossId AND isErased = TRUE)
   THEN
       RAISE EXCEPTION '������.���������� ������������ ��������� ������ ����: <%>, <%>, <%>, <%>', lfGet_Object_ValueData (inProfitLossGroupId), lfGet_Object_ValueData (inProfitLossDirectionId), lfGet_Object_ValueData (inInfoMoneyDestinationId), lfGet_Object_ValueData (inInfoMoneyId);
   END IF;


   -- ������� ����� ������ ����
   IF COALESCE (vbProfitLossId, 0) = 0
   THEN
       -- ��� ��������� ������� ��������� �������� ����� ������ ����
       IF inInsert = FALSE
       THEN
           RAISE EXCEPTION '������.� ������ ��������� ���������� ������� ����� ������ ���� � �����������: %<%> %<%> %<%> %<%> %(%)(%)(%)'
                         , CHR (13)
                         , lfGet_Object_ValueData (inProfitLossGroupId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inProfitLossDirectionId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inInfoMoneyDestinationId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inInfoMoneyId)
                         , CHR (13)
                         , inProfitLossGroupId
                         , inProfitLossDirectionId
                         , inInfoMoneyDestinationId
                          ;
       END IF;

       -- ���������� Id 2-�� ������� �� <������ ����> � <��������� ���� - �����������>
       SELECT ProfitLossDirectionId INTO vbProfitLossDirectionId FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossGroupId = inProfitLossGroupId AND ProfitLossDirectionId = inProfitLossDirectionId;

       IF COALESCE (vbProfitLossDirectionId, 0) = 0
       THEN
            -- ���������� �������� 2-�� ������� �� <��������� ���� - �����������>
           SELECT ProfitLossDirectionName INTO vbProfitLossDirectionName FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossDirectionId = inProfitLossDirectionId;

           -- ���������� Id 2-�� ������� �� <������ ����> � vbProfitLossDirectionName
           SELECT ProfitLossDirectionId INTO vbProfitLossDirectionId FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossGroupId = inProfitLossGroupId AND ProfitLossDirectionName = vbProfitLossDirectionName;

           -- ���� Id �� �����, ������ 2-�� �������
           IF COALESCE (vbProfitLossDirectionId, 0) = 0
           THEN
               -- ���������� ������� ���
               SELECT COALESCE (MAX (ProfitLossDirectionCode), 0) + 100 INTO vbProfitLossDirectionCode FROM lfSelect_Object_ProfitLossDirection() WHERE ProfitLossGroupId = inProfitLossGroupId;
               -- ������� 2-�� �������
               vbProfitLossDirectionId := lpInsertUpdate_Object (vbProfitLossDirectionId, zc_Object_ProfitLossDirection(), vbProfitLossDirectionCode, vbProfitLossDirectionName);
               -- ��������� ��������
               PERFORM lpInsert_ObjectProtocol (vbProfitLossDirectionId, inUserId);
           END IF;

       END IF;


       -- ��� ��� ������� ������ ���� �� <�������������� ����������> ��� <������ ����������> (�� ����� ������ vbProfitLossDirectionId)
       IF inInfoMoneyDestinationId <> 0
          THEN vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoneyDestination (inProfitLossGroupId, vbProfitLossDirectionId, inInfoMoneyDestinationId);
          ELSE vbProfitLossId := lfGet_Object_ProfitLoss_byInfoMoney (inProfitLossGroupId, vbProfitLossDirectionId, inInfoMoneyId);
       END IF;

       -- ������� ����� ������ ����
       IF COALESCE (vbProfitLossId, 0) = 0
       THEN
           -- ���������� �������� 3-�� ������� �� <�������������� ����������> ��� <������ ����������>
           IF inInfoMoneyDestinationId <> 0 THEN SELECT InfoMoneyDestinationName INTO vbProfitLossName FROM lfSelect_Object_InfoMoneyDestination() WHERE InfoMoneyDestinationId = inInfoMoneyDestinationId;
                                            ELSE SELECT InfoMoneyName INTO vbProfitLossName FROM lfSelect_Object_InfoMoney() WHERE InfoMoneyId = inInfoMoneyId;
           END IF;

           -- ���������� ������� ���
           SELECT COALESCE (MAX (ProfitLossCode), 0) + 1 INTO vbProfitLossCode FROM lfSelect_Object_ProfitLoss() WHERE ProfitLossGroupId = inProfitLossGroupId AND ProfitLossDirectionId = vbProfitLossDirectionId;

           IF vbProfitLossCode = 1 THEN
             -- ���������� ������� ���
             vbProfitLossCode:= vbProfitLossDirectionCode + 1;
           END IF;

           -- ������ 3-�� �������
           vbProfitLossId := lpInsertUpdate_Object (vbProfitLossId, zc_Object_ProfitLoss(), vbProfitLossCode, vbProfitLossName);
           -- ��� �������� ��� 3-�� �������
           PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ProfitLoss_onComplete(), vbProfitLossId, TRUE);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_ProfitLossGroup(), vbProfitLossId, inProfitLossGroupId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_ProfitLossDirection(), vbProfitLossId, vbProfitLossDirectionId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_InfoMoneyDestination(), vbProfitLossId, inInfoMoneyDestinationId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProfitLoss_InfoMoney(), vbProfitLossId, inInfoMoneyId);

           -- ��������� ��������
           PERFORM lpInsert_ObjectProtocol (vbProfitLossId, inUserId);
       END IF;

   END IF;


   -- ���������� ��������
   RETURN (vbProfitLossId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_ProfitLoss (Integer, Integer, Integer, Integer, Boolean, Integer)  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.10.14                                        * add ������ (10200)������ ����� -> (20600)������ ��������� � ...
 31.01.14                                        * add �������� - ������ �� ������ ���� �������
 30.01.14                                        * add !!!������ ������� ������!!!, �.�. inInsert = FALSE
 23.12.13                                        * add inInsert
 26.08.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_ProfitLoss (inProfitLossGroupId:= zc_Enum_ProfitLossGroup_100000(), inProfitLossDirectionId:= 23581, inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_10100(), inInfoMoneyId:= 0, inUserId:= 2)
--
-- SELECT * FROM lfSelect_Object_ProfitLoss () order by 8
