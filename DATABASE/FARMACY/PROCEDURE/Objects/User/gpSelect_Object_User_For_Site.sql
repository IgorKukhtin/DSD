-- Function: gpSelect_Object_User_For_Site()

DROP FUNCTION IF EXISTS gpSelect_Object_User_For_Site (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User_For_Site(
    IN inUnitId        Integer,       -- ������
    IN inSession       TVarChar       -- ������ ������������    
)
RETURNS TABLE (Id         Integer    -- ���� ������������
             , Name       TVarChar   -- ���
             , Foto       TVarChar   -- ����
             , DateIn     TDateTime  -- ���� � �������� ����� ��������
             , DateAction TDateTime  -- ����/ ����� ��������� ����������
             , UnitId     Integer    -- ���� ������
             , UnitName   TVarChar   -- ������
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
       WITH tmpUser AS (SELECT Object_User.Id AS UserId
                             , COALESCE (Object_Member.ValueData, Object_User.ValueData) AS Name
                             , ObjectString_Foto.ValueData AS Foto
                             , Object_Member.Id AS MemberId
                             , zfConvert_StringToNumber (DefaultValue.DefaultValue) AS UnitId
                        FROM DefaultKeys
                             INNER JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                                                    AND (DefaultValue.DefaultValue = inUnitId :: TVarChar
                                                      OR COALESCE (inUnitId, 0) = 0)
                             INNER JOIN Object AS Object_User ON Object_User.Id       = DefaultValue.UserKeyId
                                                             AND Object_User.DescId   = zc_Object_User()
                                                             AND Object_User.isErased = FALSE
                             LEFT JOIN ObjectString AS ObjectString_Foto
                                                    ON ObjectString_Foto.ObjectId  = Object_User.Id
                                                   AND ObjectString_Foto.DescId    = 1
                
                             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                  ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                             LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                
                        WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit')
                       )
          , tmpPersonal AS (SELECT View_Personal.MemberId
                                 , View_Personal.UnitId
                                 , View_Personal.PositionId
                                 , View_Personal.DateIn
                                   --  � �/�
                                 , ROW_NUMBER() OVER (PARTITION BY View_Personal.MemberId ORDER BY View_Personal.PersonalId ASC) AS Ord
                            FROM Object_Personal_View AS View_Personal
                            WHERE View_Personal.isErased = FALSE
                           )

        SELECT
             tmpUser.UserId AS Id
           , tmpUser.Name :: TVarChar AS Name
           , tmpUser.Foto          
           , tmpPersonal.DateIn
           , tmpPersonal.DateIn    AS DateAction
           , Object_Unit.Id        AS UnitId
           , Object_Unit.ValueData AS UnitName
        FROM tmpUser
             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpUser.MemberId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
        WHERE tmpUser.UnitId > 0
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 08.09.17                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_User_For_Site (inUnitId:= 375626, inSession:= '3'); -- ������_1 ��_������_40 WHERE DateAction >= '08.09.2017'
