-- Function: gpSelect_Object_InfoMoney_choice()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_choice (Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney_choice(
    IN inIsService   Boolean,       -- ���������� ������ �� ���������� �� / ���
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ���
    IN inKindName    TVarChar,      -- ����� ������ ���������� ������ ������ ��� ������ ������ 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
             , ParentId Integer, ParentName TVarChar
             , GroupNameFull TVarChar
             , isUserAll Boolean, isService Boolean
             , NPP Integer
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT tmp.Id          AS Id 
        , tmp.Code
        , tmp.Name
        , tmp.isErased
        
        , tmp.InfoMoneyKindId
        , tmp.InfoMoneyKindName
        , tmp.ParentId
        , tmp.ParentName
        
        , tmp.GroupNameFull
        , tmp.isUserAll
        , tmp.isService
        
        , tmp.NPP

        , tmp.InsertName
        , tmp.InsertDate
        , tmp.UpdateName
        , tmp.UpdateDate
   FROM gpSelect_Object_InfoMoney (inIsShowAll, inSession) AS tmp
        LEFT JOIN ObjectLink AS ObjectLink_Child
                             ON ObjectLink_Child.ChildObjectId = tmp.Id
                            AND ObjectLink_Child.DescId        = zc_ObjectLink_InfoMoney_Parent()
   WHERE (tmp.isService = inIsService OR inIsService = FALSE)
     AND ObjectLink_Child.ObjectId IS NULL
  /*AND ((inKindName = 'zc_Enum_InfoMoney_In' AND (tmp.InfoMoneyKindId = zc_Enum_InfoMoney_In() OR COALESCE (tmp.InfoMoneyKindId,0)=0) ) 
      OR (inKindName = 'zc_Enum_InfoMoney_Out' AND (tmp.InfoMoneyKindId = zc_Enum_InfoMoney_Out() OR COALESCE (tmp.InfoMoneyKindId,0)=0) )
      OR COALESCE (inKindName,'') = ''  
        )*/
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.22         * inKindName
 14.01.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoney_choice (TRUE, FALSE, '', zfCalc_UserAdmin())
