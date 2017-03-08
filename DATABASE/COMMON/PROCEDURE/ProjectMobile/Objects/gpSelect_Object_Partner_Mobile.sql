-- Function: gpSelect_Object_Partner_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Mobile (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_Mobile (
     IN inisShowAll  Boolean  , --
     IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id              Integer
             , Code            Integer  -- ���
             , Name            TVarChar -- ��������
             , Address         TVarChar -- ����� ����� ��������
             , GPSN            TFloat   -- GPS ���������� ����� �������� (������)
             , GPSE            TFloat   -- GPS ���������� ����� �������� (�������)
             , Schedule        TVarChar -- ������ ��������� �� - �� ����� ���� ������ - � ������� 7 �������� ����������� ";" t ������ true � f ������ false
             , DebtSum         TFloat   -- ����� ����� (���) - ��� - �.� ��� ���� ����������� ������ � ������� ������������ + ��������� + ��� ��������� �� � ���������
             , OverSum         TFloat   -- ����� ������������� ����� (���) - ��� - ��������� ��������� ������ ������������ ���-�� ����
             , OverDays        Integer  -- ���-�� ���� ��������� (���)
             , PrepareDayCount Integer  -- �� ������� ���� ����������� �����
             , JuridicalId     Integer  -- ����������� ����
             , JuridicalName   TVarChar --
             , RouteId         Integer  -- �������
             , RouteName       TVarChar  -- 
             , ContractId      Integer  -- ������� - ��� ��������� ��������...
             , ContractName    TVarChar  -- 
             , PriceListId     Integer  -- �����-���� - �� ����� ����� ����� ������������� �����
             , PriceListName   TVarChar  --
             , PriceListId_ret Integer  -- �����-���� �������� - �� ����� ����� ����� ������������� �������
             , PriceListName_ret TVarChar  --
             , isErased        Boolean  -- ��������� �� �������
             , isSync          Boolean  -- ���������������� (��/���)

             , Value1 Boolean, Value2 Boolean, Value3 Boolean, Value4 Boolean
             , Value5 Boolean, Value6 Boolean, Value7 Boolean
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      RETURN QUERY
          SELECT tmpMobilePartner.Id
               , tmpMobilePartner.ObjectCode AS Code
               , tmpMobilePartner.ValueData  AS Name
               , tmpMobilePartner.Address
               , tmpMobilePartner.GPSN
               , tmpMobilePartner.GPSE
               , tmpMobilePartner.Schedule
               , tmpMobilePartner.DebtSum
               , tmpMobilePartner.OverSum
               , tmpMobilePartner.OverDays
               , tmpMobilePartner.PrepareDayCount
               , Object_Juridical.Id            AS JuridicalId
               , Object_Juridical.ValueData     AS JuridicalName
               , Object_Route.Id                AS RouteId
               , Object_Route.ValueData         AS RouteName

               , Object_Contract.Id             AS ContractId
               , Object_Contract.ValueData      AS ContractName
               , Object_PriceList.Id            AS PriceListId
               , Object_PriceList.ValueData     AS PriceListName
               , Object_PriceList_Ret.Id        AS PriceListId_ret
               , Object_PriceList_Ret.ValueData AS PriceListName_ret
               , tmpMobilePartner.isErased
               , tmpMobilePartner.isSync

               , zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 1) ::Boolean   AS Value1
               , zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 2) ::Boolean   AS Value2
               , zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 3) ::Boolean   AS Value3
               , zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 4) ::Boolean   AS Value4
               , zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 5) ::Boolean   AS Value5
               , zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 6) ::Boolean   AS Value6
               , zfCalc_Word_Split (inValue:= tmpMobilePartner.Schedule, inSep:= ';', inIndex:= 7) ::Boolean   AS Value7

          FROM gpSelectMobile_Object_Partner (zc_DateStart(), inSession) AS tmpMobilePartner
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMobilePartner.JuridicalId 
               LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMobilePartner.RouteId 
               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpMobilePartner.ContractId 
               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMobilePartner.PriceListId 
               LEFT JOIN Object AS Object_PriceList_Ret ON Object_PriceList_Ret.Id = tmpMobilePartner.PriceListId_ret 
          WHERE tmpMobilePartner.isSync = TRUE
           AND ( tmpMobilePartner.isErased = inisShowAll OR inisShowAll = True)
;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 07.03.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Partner_Mobile(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
