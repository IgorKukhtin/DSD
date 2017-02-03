-- Function: gpSelect_Object_Member_Desc (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member_Desc (TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member_Desc(
    IN inDescCode    TVarChar,      --
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar, DriverCertificate TVarChar, Card TVarChar, Comment TVarChar
             , isOfficial Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , StartSummerDate TDateTime, EndSummerDate TDateTime
             , SummerFuel TFloat, WinterFuel TFloat, Reparation TFloat, LimitMoney TFloat, LimitDistance TFloat
             , CarNameAll TVarChar, CarName TVarChar, CarModelName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , ObjectToId Integer, ObjectToName TVarChar, DescName TVarChar
             , isDateOut Boolean, PersonalId Integer
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���������
   RETURN QUERY 
       WITH tmpDesc AS (SELECT ObjectDesc.Id
                             , CASE WHEN ObjectDesc.Id = zc_Object_Member()
                                         THEN zc_ContainerLinkObject_Member()
                                    ELSE 0
                               END AS DescId
                        FROM ObjectDesc
                        WHERE ObjectDesc.Code = inDescCode
                       )
          , tmpContainer AS (SELECT ContainerLinkObject.ObjectId AS MemberId
                             FROM tmpDesc
                                  INNER JOIN Object ON Object.DescId = tmpDesc.Id
                                  INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = Object.Id
                                                                AND (ContainerLinkObject.DescId = tmpDesc.DescId
                                                                  OR tmpDesc.DescId = 0)
                                  INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                      AND Container.DescId = zc_Container_Summ()
                             GROUP BY ContainerLinkObject.ObjectId
                            )
          , tmpMember AS (SELECT * FROM gpSelect_Object_Member (inIsShowAll, inSession))

       -- ���������
       SELECT tmpMember.Id
            , tmpMember.Code, tmpMember.Name
             , tmpMember.INN, tmpMember.DriverCertificate, tmpMember.Card, tmpMember.Comment
             , tmpMember.isOfficial
             , tmpMember.InfoMoneyId, tmpMember.InfoMoneyCode, tmpMember.InfoMoneyName, tmpMember.InfoMoneyName_all
             , tmpMember.StartSummerDate, tmpMember.EndSummerDate
             , tmpMember.SummerFuel, tmpMember.WinterFuel, tmpMember.Reparation, tmpMember.LimitMoney, tmpMember.LimitDistance
             , tmpMember.CarNameAll, tmpMember.CarName, tmpMember.CarModelName
             , tmpMember.BranchCode, tmpMember.BranchName
             , tmpMember.UnitCode, tmpMember.UnitName
             , tmpMember.PositionCode, tmpMember.PositionName
             , tmpMember.ObjectToId, tmpMember.ObjectToName, tmpMember.DescName
             , tmpMember.isDateOut, tmpMember.PersonalId
             , tmpMember.isErased
       FROM tmpContainer
            INNER JOIN tmpMember ON tmpMember.Id = tmpContainer.MemberId
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Member_Desc (TVarChar, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.04.15                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Member_Desc ('zc_Object_Member', FALSE, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Member_Desc ('zc_Object_Member', TRUE, zfCalc_UserAdmin())
