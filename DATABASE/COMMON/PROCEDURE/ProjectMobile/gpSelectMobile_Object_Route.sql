-- Function: gpSelectMobile_Object_Route (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Route (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Route (
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- ���
             , ValueData  TVarChar -- ��������
             , isErased   Boolean  -- ��������� �� �������
             , isSync     Boolean  -- ���������������� (��/���)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpRoute AS (SELECT ObjectLink_Partner_Route.ChildObjectId AS RouteId
                               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                    JOIN ObjectLink AS ObjectLink_Partner_Route
                                                    ON ObjectLink_Partner_Route.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                   AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
                               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 AND ObjectLink_Partner_Route.ChildObjectId IS NOT NULL
                              )
                , tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS RouteId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_Route
                                                   ON Object_Route.Id = ObjectProtocol.ObjectId
                                                  AND Object_Route.DescId = zc_Object_Route() 
                                  WHERE ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
             SELECT Object_Route.Id
                  , Object_Route.ObjectCode
                  , Object_Route.ValueData
                  , Object_Route.isErased
                  , EXISTS(SELECT 1 FROM tmpRoute WHERE tmpRoute.RouteId = Object_Route.Id) AS isSync
             FROM Object AS Object_Route
                  JOIN tmpProtocol ON tmpProtocol.RouteId = Object_Route.Id
             WHERE Object_Route.DescId = zc_Object_Route();
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
-- SELECT * FROM gpSelectMobile_Object_Route(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
