-- Function: gpInsertUpdate_Object_ContractCondition(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractCondition(
 INOUT ioId                        Integer   , -- ���� ������� <������� ��������>
    IN inComment                   TVarChar  , -- ����������
    IN inValue                     TFloat    , -- ��������
    IN inPercentRetBonus           TFloat    , -- % �������� ����
    IN inContractId                Integer   , -- �������
    IN inContractConditionKindId   Integer   , -- ���� ������� ��������� 
    IN inBonusKindId               Integer   , -- ���� �������
    IN inInfoMoneyId               Integer   , -- ������ ����������
    IN inContractSendId            Integer   , -- ������� ����������
    IN inPaidKindId                Integer   , -- ����� ������
    IN inStartDate                 TDateTime , -- �������� �...
   OUT outEndDate                  TDateTime , -- �������� ��...
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   IF ioId > 0
   THEN
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractCondition());
   ELSE
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   END IF;
  
    -- ��������
   IF COALESCE (inContractId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ����������.';
   END IF;

   -- �������� �� ������������, ������ �������� � ������������ StartDate
   IF COALESCE (inStartDate, zc_DateStart()) > zc_DateStart()
   THEN
        IF EXISTS (SELECT 1
                   FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                       INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                             ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                            AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                            AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = inContractConditionKindId
                       INNER JOIN ObjectDate AS ObjectDate_StartDate
                                             ON ObjectDate_StartDate.ObjectId  = ObjectLink_ContractCondition_Contract.ObjectId
                                            AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractCondition_StartDate()
                                            AND ObjectDate_StartDate.ValueData = inStartDate
                   WHERE ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
                     AND ObjectLink_ContractCondition_Contract.ObjectId <> ioId
                     AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract())
        THEN
            RAISE EXCEPTION '������.���� ������ �������� ������� �������� �� ���������.';
        END IF;
   END IF;
   
   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractCondition(), 0, inComment);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractCondition_Value(), ioId, inValue);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractCondition_PercentRetBonus(), ioId, inPercentRetBonus);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_Contract(), ioId, inContractId);   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractConditionKind(), ioId, inContractConditionKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_BonusKind(), ioId, inBonusKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_InfoMoney(), ioId, inInfoMoneyId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_ContractSend(), ioId, inContractSendId);   

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractCondition_PaidKind(), ioId, inPaidKindId); 

   IF COALESCE (inStartDate, zc_DateStart()) > zc_DateStart() OR 1 < (SELECT COUNT(*)
                                                                      FROM ObjectLink AS ObjectLink_Contract
                                                                           INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                                                                 ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                                                                AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                                                                AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                                                                        AND Object_ContractCondition.isErased = FALSE
                                                                      WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                                                        AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                                                                     )
                                                              OR EXISTS (SELECT 1
                                                                         FROM ObjectDate AS ObjectDate_EndDate
                                                                         WHERE ObjectDate_EndDate.ObjectId  = ioId
                                                                           AND ObjectDate_EndDate.DescId    = zc_ObjectDate_ContractCondition_EndDate()
                                                                           AND ObjectDate_EndDate.ValueData IS NOT NULL
                                                                        )
   THEN
       -- StartDate - ���������
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_StartDate(), ioId, inStartDate);
       
       -- EndDate - �������� ����
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), tmp.Id, NULL)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId AS Id
                              FROM ObjectLink AS ObjectLink_Contract
                                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                         ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                        AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                        AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                   INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                         ON ObjectDate_EndDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                        AND ObjectDate_EndDate.DescId    = zc_ObjectDate_ContractCondition_EndDate()
                                                        AND ObjectDate_EndDate.ValueData IS NOT NULL
                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                             )
             SELECT tmpData.Id
             FROM tmpData
             ) AS tmp
            ;

       -- EndDate - �������� ����
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), tmp.Id, tmp.EndDate)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId                          AS Id
                                   , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart()) AS StartDate
                                   , ROW_NUMBER() OVER (ORDER BY COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart()) ASC) AS Ord
                              FROM ObjectLink AS ObjectLink_Contract
                                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                         ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                        AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                        AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                   INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                                AND Object_ContractCondition.isErased = FALSE
                                   LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                        ON ObjectDate_StartDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                       AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractCondition_StartDate()
                                                     --AND ObjectDate_StartDate.ValueData > zc_DateStart()
                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                             )
             SELECT tmpData.Id, COALESCE (tmpData_next.StartDate - INTERVAL '1 DAY', zc_DateEnd()) AS EndDate
             FROM tmpData
                  LEFT JOIN tmpData AS tmpData_next ON tmpData_next.Ord       = tmpData.Ord + 1
                                                   AND tmpData_next.StartDate > zc_DateStart()
             ) AS tmp
      ;


   END IF;
   

   -- ������ � ���� ��� +  % ������� ��������� (������ ����������) 
   IF inContractConditionKindId NOT IN (WITH tmpOS AS (SELECT * FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Enum())
                                        SELECT zc_Enum_ContractConditionKind_ChangePrice() UNION SELECT zc_Enum_ContractConditionKind_ChangePercentPartner()
                                  UNION SELECT zc_Enum_ContractConditionKind_ChangePercent()
                                  UNION SELECT zc_Enum_ContractConditionKind_DelayDayCalendar() UNION SELECT zc_Enum_ContractConditionKind_DelayDayBank()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                  UNION SELECT tmpOS.ObjectId FROM tmpOS WHERE tmpOS.ValueData ILIKE 'zc_Enum_ContractConditionKind_Transport%'
                                  --
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentAccount()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentSale()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                  UNION SELECT zc_Enum_ContractConditionKind_BonusPercentSalePart()
                                       )
 --AND vbUserId = 5
   AND 0 < (WITH tmpData AS (SELECT ObjectLink_ContractConditionKind.ChildObjectId                          AS ContractConditionKindId
                                  , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
                                --, COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate
                             FROM ObjectLink AS ObjectLink_Contract
                                  INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                        ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                       AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                  INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                               AND Object_ContractCondition.isErased = FALSE
                                  LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                       ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                                      AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractCondition_StartDate()
                                --LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                --                     ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                --                    AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractCondition_EndDate()
                             WHERE ObjectLink_Contract.ChildObjectId = inContractId
                               AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                            )
            SELECT COUNT(*)
            FROM tmpData
                 JOIN tmpData AS tmpData_next ON tmpData_next.ContractConditionKindId = tmpData.ContractConditionKindId
                                             AND tmpData_next.StartDate               > tmpData.StartDate
           )
   THEN
       RAISE EXCEPTION '������.��� ������� �������� <%> ������� �� �������������.', lfGet_Object_ValueData_sh (inContractConditionKindId);
   END IF;

   -- ���� ������ ������� ������ ����� �������� ���� ��������� ����������� ������� ��������,   � ���������� ��/� ������ ��������� zc_DateEnd()
   -- ������� �������
   IF COALESCE (inContractConditionKindId, 0) = 0
   THEN
       --
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_StartDate(), ioId, NULL);
       --
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), ioId, NULL);   

       -- EndDate - �������� ����
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractCondition_EndDate(), tmp.Id, tmp.EndDate)
       FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId                          AS Id
                                   , ObjectDate_StartDate.ValueData                        AS StartDate
                                   , COALESCE (ObjectLink_ContractConditionKind.ChildObjectId, ObjectLink_Contract.ObjectId) AS ObjectId
                                   , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectLink_ContractConditionKind.ChildObjectId, ObjectLink_Contract.ObjectId) ORDER BY ObjectDate_StartDate ASC) AS Ord
                              FROM ObjectLink AS ObjectLink_Contract
                                   LEFT JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                        ON ObjectLink_ContractConditionKind.ObjectId      = ObjectLink_Contract.ObjectId
                                                       AND ObjectLink_ContractConditionKind.DescId        = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                     --AND ObjectLink_ContractConditionKind.ChildObjectId = inContractConditionKindId
                                   INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_Contract.ObjectId
                                                                                AND Object_ContractCondition.isErased = FALSE
                                   INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                         ON ObjectDate_StartDate.ObjectId  = ObjectLink_Contract.ObjectId
                                                        AND ObjectDate_StartDate.DescId    = zc_ObjectDate_ContractCondition_StartDate()
                                                        AND ObjectDate_StartDate.ValueData > zc_DateStart()
                              WHERE ObjectLink_Contract.ChildObjectId = inContractId
                                AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractCondition_Contract()
                             )
             SELECT tmpData.Id, COALESCE (tmpData_next.StartDate - INTERVAL '1 DAY', zc_DateEnd()) AS EndDate
             FROM tmpData
                  LEFT JOIN tmpData AS tmpData_next ON tmpData_next.Ord       = tmpData.Ord + 1
                                                   AND tmpData_next.ObjectId  = tmpData.ObjectId
                                                   AND tmpData_next.StartDate > zc_DateStart()
             ) AS tmp
      ;
   END IF;

   -- ������� ����� ��������
   outEndDate:= (SELECT ObjectDate_EndDate.ValueData
                 FROM ObjectDate AS ObjectDate_EndDate
                 WHERE ObjectDate_EndDate.ObjectId  = ioId
                   AND ObjectDate_EndDate.DescId    = zc_ObjectDate_ContractCondition_EndDate()
                );
   
   --
   IF vbUserId = 5 AND 1=0
   THEN
       RAISE EXCEPTION '������.%.', outEndDate;
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_ContractCondition (Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.05.20         * add inPercentRetBonus
 20.05.20         * add inPaidKindId
 24.03.20         * add inStartDate
 08.05.14                                        * add lpCheckRight
 14.03.14         * add InfoMoney
 25.02.14                                        * add inIsUpdate and inIsErased
 19.02.14         * add inBonusKindId, inComment
 16.11.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ContractCondition (ioId:=0, inValue:=100, inContractId:=5, inContractConditionKindId:=6, inSession:='2')
