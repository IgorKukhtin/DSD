-- Function: gpSelectMobile_Object_Contract (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Contract (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Contract (
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer   -- ���
             , ValueData        TVarChar  -- ��������
             , ContractTagName  TVarChar  -- ������� ��������
             , InfoMoneyName    TVarChar  -- �� ������
             , Comment          TVarChar  -- ����������
             , PaidKindId       Integer   -- ����� ������
             , StartDate        TDateTime -- ���� � ������� ��������� �������
             , EndDate          TDateTime -- ���� �� ������� ��������� �������
             , ChangePercent    TFloat    -- (-)% ������ (+)% ������� - ��� ������ - ������������� ��������, ��� ������� - �������������
             , DelayDayCalendar TFloat    -- �������� � ����������� ����
             , DelayDayBank     TFloat    -- �������� � ���������� ����
             , isErased         Boolean   -- ��������� �� �������
             , isSync           Boolean   -- ���������������� (��/���)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- !!!��������!!!
      inSyncDateIn:= zc_DateStart();


      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL
      THEN
           CREATE TEMP TABLE tmpContractCondition ON COMMIT DROP
           AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId              AS ContractId
                    , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                    , CASE WHEN ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                            AND MIN (ObjectFloat_ContractCondition_Value.ValueData) < 0.0
                                THEN (MIN (ABS (ObjectFloat_ContractCondition_Value.ValueData)) * -1.0)::TFloat
                                ELSE MIN (ObjectFloat_ContractCondition_Value.ValueData)::TFloat
                      END AS ContractConditionKindValue
               FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                    JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                   AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_ChangePercent()
                                                                                                          , zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                                          , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                                           )
                    JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                                     ON ObjectFloat_ContractCondition_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                    AND ObjectFloat_ContractCondition_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                    AND ObjectFloat_ContractCondition_Value.ValueData <> 0.0
                    JOIN Object AS Object_ContractCondition
                                ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId
                               AND NOT Object_ContractCondition.isErased
                    JOIN Object AS Object_Contract
                                ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId
                               AND NOT Object_Contract.isErased
               WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
               GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                      , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
              );

           CREATE TEMP TABLE tmpContract ON COMMIT DROP
           AS (-- ���� vbPersonalId - ��������� (��������)
               SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
               FROM ObjectLink AS OL
                    JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = OL.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                    JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                    ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                   AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
               WHERE OL.ChildObjectId = vbPersonalId
                 AND OL.DescId        = zc_ObjectLink_Partner_PersonalTrade()
              UNION
               -- ���� vbPersonalId - ��������� (�����������)
               SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
               FROM ObjectLink AS OL
                    JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = OL.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                    JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                    ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                   AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
               WHERE OL.ChildObjectId = vbPersonalId
                 AND OL.DescId        = zc_ObjectLink_Partner_Personal()
              UNION
               -- ���� vbPersonalId - ��������� (������������)
               SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
               FROM ObjectLink AS OL
                    JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = OL.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                    JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                    ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                   AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Partner_PersonalMerch()
               WHERE OL.ChildObjectId = vbPersonalId
                 AND OL.DescId        = zc_ObjectLink_Partner_PersonalMerch()
              );

           IF inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS ContractId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol
                                            JOIN Object AS Object_Contract
                                                        ON Object_Contract.Id = ObjectProtocol.ObjectId
                                                       AND Object_Contract.DescId = zc_Object_Contract()
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId
                                      )
                  SELECT Object_Contract.Id
                       , Object_Contract.ObjectCode
                       , Object_Contract.ValueData
                       , Object_ContractTag.ValueData               AS ContractTagName
                       , Object_InfoMoney.ValueData                 AS InfoMoneyName
                       , ObjectString_Contract_Comment.ValueData    AS Comment
                       , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
                       , ObjectDate_Contract_Start.ValueData        AS StartDate
                       , ObjectDate_Contract_End.ValueData          AS EndDate
                       , COALESCE (tmpChangePercent.ContractConditionKindValue, 0.0)::TFloat    AS ChangePercent
                       , COALESCE (tmpDelayDayCalendar.ContractConditionKindValue, 0.0)::TFloat AS DelayDayCalendar
                       , COALESCE (tmpDelayDayBank.ContractConditionKindValue, 0.0)::TFloat     AS DelayDayBank
                       , Object_Contract.isErased
                       , CASE WHEN -- ��������� - ���� ������
                                   Object_Contract.isErased = TRUE
                                   -- ��������� - ���� ��������
                                OR COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, zc_Enum_ContractStateKind_Close()) = zc_Enum_ContractStateKind_Close()
                                   -- ��������� - ���� �� ��
                                OR COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) <> zc_Enum_InfoMoney_30101() -- ������ + ��������� + ������� ���������
                                   THEN FALSE

                              WHEN tmpContract.ContractId IS NULL
                                   THEN FALSE

                              ELSE TRUE

                         END :: Boolean AS isSync

                  FROM Object AS Object_Contract
                       JOIN tmpProtocol ON tmpProtocol.ContractId = Object_Contract.Id

                       -- ��������� - ���� ��������� �������� - �� ��������
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                            ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_ContractStateKind.DescId   = zc_ObjectLink_Contract_ContractStateKind()
                       -- ��������� - ������ ���� ��
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

                       LEFT JOIN tmpContract ON tmpContract.ContractId = Object_Contract.Id
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                       LEFT JOIN ObjectString AS ObjectString_Contract_Comment
                                              ON ObjectString_Contract_Comment.ObjectId = Object_Contract.Id
                                             AND ObjectString_Contract_Comment.DescId = zc_ObjectString_Contract_Comment()
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_Start
                                            ON ObjectDate_Contract_Start.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_Start.DescId = zc_ObjectDate_Contract_Start()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_End
                                            ON ObjectDate_Contract_End.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_End.DescId = zc_ObjectDate_Contract_End()
                       LEFT JOIN tmpContractCondition AS tmpChangePercent
                                                      ON tmpChangePercent.ContractId = Object_Contract.Id
                                                     AND tmpChangePercent.ContractConditionKindId = zc_Enum_ContractConditionKind_ChangePercent()
                       LEFT JOIN tmpContractCondition AS tmpDelayDayCalendar
                                                      ON tmpDelayDayCalendar.ContractId = Object_Contract.Id
                                                     AND tmpDelayDayCalendar.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                       LEFT JOIN tmpContractCondition AS tmpDelayDayBank
                                                      ON tmpDelayDayBank.ContractId = Object_Contract.Id
                                                     AND tmpDelayDayBank.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                  WHERE Object_Contract.DescId   = zc_Object_Contract()
                    AND Object_Contract.isErased = FALSE -- ��������� - ���� �� ������
                 ;
           ELSE
                RETURN QUERY
                  SELECT Object_Contract.Id
                       , Object_Contract.ObjectCode
                       , Object_Contract.ValueData
                       , Object_ContractTag.ValueData               AS ContractTagName
                       , Object_InfoMoney.ValueData                 AS InfoMoneyName
                       , ObjectString_Contract_Comment.ValueData    AS Comment
                       , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
                       , ObjectDate_Contract_Start.ValueData        AS StartDate
                       , ObjectDate_Contract_End.ValueData          AS EndDate
                       , COALESCE (tmpChangePercent.ContractConditionKindValue, 0.0)::TFloat    AS ChangePercent
                       , COALESCE (tmpDelayDayCalendar.ContractConditionKindValue, 0.0)::TFloat AS DelayDayCalendar
                       , COALESCE (tmpDelayDayBank.ContractConditionKindValue, 0.0)::TFloat     AS DelayDayBank
                       , Object_Contract.isErased

                       , CASE WHEN -- ��������� - ���� ������
                                   Object_Contract.isErased = TRUE
                                   -- ��������� - ���� ��������
                                OR COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, zc_Enum_ContractStateKind_Close()) = zc_Enum_ContractStateKind_Close()
                                   -- ��������� - ���� �� ��
                                OR COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) <> zc_Enum_InfoMoney_30101() -- ������ + ��������� + ������� ���������
                                   THEN FALSE
                              ELSE TRUE
                         END :: Boolean AS isSync

                  FROM Object AS Object_Contract
                       JOIN tmpContract ON tmpContract.ContractId = Object_Contract.Id

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                            ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_ContractStateKind.DescId   = zc_ObjectLink_Contract_ContractStateKind()
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                            AND ObjectLink_Contract_InfoMoney.DescId  = zc_ObjectLink_Contract_InfoMoney()
                       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                       LEFT JOIN ObjectString AS ObjectString_Contract_Comment
                                              ON ObjectString_Contract_Comment.ObjectId = Object_Contract.Id
                                             AND ObjectString_Contract_Comment.DescId = zc_ObjectString_Contract_Comment()
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_Start
                                            ON ObjectDate_Contract_Start.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_Start.DescId = zc_ObjectDate_Contract_Start()
                       LEFT JOIN ObjectDate AS ObjectDate_Contract_End
                                            ON ObjectDate_Contract_End.ObjectId = Object_Contract.Id
                                           AND ObjectDate_Contract_End.DescId = zc_ObjectDate_Contract_End()
                       LEFT JOIN tmpContractCondition AS tmpChangePercent
                                                      ON tmpChangePercent.ContractId = Object_Contract.Id
                                                     AND tmpChangePercent.ContractConditionKindId = zc_Enum_ContractConditionKind_ChangePercent()
                       LEFT JOIN tmpContractCondition AS tmpDelayDayCalendar
                                                      ON tmpDelayDayCalendar.ContractId = Object_Contract.Id
                                                     AND tmpDelayDayCalendar.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                       LEFT JOIN tmpContractCondition AS tmpDelayDayBank
                                                      ON tmpDelayDayBank.ContractId = Object_Contract.Id
                                                     AND tmpDelayDayBank.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                  WHERE Object_Contract.DescId   = zc_Object_Contract()
                 ;
           END IF;
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 17.02.17                                                         *
*/

-- ����
-- SELECT * FROM gpSelectMobile_Object_Contract (inSyncDateIn := zc_DateStart(), inSession := '347628') -- ���� �.�.
-- SELECT * FROM gpSelectMobile_Object_Contract (inSyncDateIn := zc_DateStart(), inSession := '1000167') WHERE ObjectCode in (4859, 4572, 4532) -- �������� �.�.
-- SELECT * FROM gpSelectMobile_Object_Contract (inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
