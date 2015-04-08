-- Function: gpSelect_Object_InfoMoney_Desc (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Desc (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney_Desc(
    IN inDescCode    TVarChar,      --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ��������� 
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
       WITH tmpDesc AS (SELECT ObjectDesc.Id
                             , CASE WHEN ObjectDesc.Id = zc_Object_Juridical()
                                         THEN zc_ContainerLinkObject_Juridical()
                                    WHEN ObjectDesc.Id = zc_Object_Member()
                                         THEN zc_ContainerLinkObject_Member()
                                    ELSE 0
                               END AS DescId
                        FROM ObjectDesc
                        WHERE ObjectDesc.Code = inDescCode
                       )
          , tmpContainer AS (SELECT ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                             FROM tmpDesc
                                  INNER JOIN Object ON Object.DescId = tmpDesc.Id
                                  INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = Object.Id
                                                                AND (ContainerLinkObject.DescId = tmpDesc.DescId
                                                                  OR tmpDesc.DescId = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = ContainerLinkObject.ContainerId
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND ContainerLinkObject_InfoMoney.ObjectId > 0
                                  INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                      AND Container.DescId = zc_Container_Summ()
                             GROUP BY ContainerLinkObject_InfoMoney.ObjectId
                            )
          , tmpLevel AS (SELECT InfoMoneyId FROM lfSelect_Object_InfoMoney_Level (vbUserId))
          , tmpInfoMoney AS (SELECT * FROM gpSelect_Object_InfoMoney (inSession))

       -- ���������
       SELECT tmpInfoMoney.*
       FROM tmpContainer
            INNER JOIN tmpLevel ON tmpLevel.InfoMoneyId = tmpContainer.InfoMoneyId
            INNER JOIN tmpInfoMoney ON tmpInfoMoney.Id = tmpContainer.InfoMoneyId
      /*UNION
       SELECT tmpInfoMoney.*
       FROM tmpInfoMoney 
       WHERE tmpInfoMoney.Id = 0*/
       ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoney_Desc (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.04.15                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoney_Desc ('zc_Object_Juridical', zfCalc_UserAdmin()) ORDER BY Code
