-- Function: gpUpdate_Movement_OrderExternal_CarInfo()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_CarInfo(
    IN inOperDate                TDateTime , -- ���� ���������
    IN inOperDatePartner         TDateTime , -- ���� �������� �� ������
    IN inOperDate_CarInfo        TDateTime , --
    IN inToId                    Integer   , -- ���� (� ���������)
    IN inRouteId                 Integer   , -- �������
    IN inRetailId                Integer   , -- ����. ����
    IN inCarInfoId               Integer   , --
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     
     ---
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), tmp.Id, inOperDate_CarInfo)        -- ����/����� ��������
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarInfo(), tmp.Id, inCarInfoId)   -- ���������� �� �������� 
     FROM (SELECT Movement.Id
           FROM Movement
               INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                      AND MovementDate_OperDatePartner.ValueData = inOperDatePartner
 
               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            AND COALESCE (MovementLinkObject_To.ObjectId,0) = inToId
 
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                            ON MovementLinkObject_Route.MovementId = Movement.Id
                                           AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
 
               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
 
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                           
           WHERE Movement.OperDate = inOperDate
             AND Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.DescId = zc_Movement_OrderExternal()
             AND inRetailId = COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE ObjectLink_Juridical_Retail.ChildObjectId END, 0)
             AND COALESCE (MovementLinkObject_Route.ObjectId, 0) = inRouteId
             ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.06.22         *
*/

-- ����
-- 