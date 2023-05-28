-- Function: gpUpdate_Movement_OrderExternal_CarInfo()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat,  TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_CarInfo(
    IN inOperDate                TDateTime , -- ���� ���������
    IN inOperDatePartner         TDateTime , -- ���� �������� �� ������
   OUT outOperDate_CarInfo       TDateTime , --
   OUT outDayName                TVarChar  , --
    IN inToId                    Integer   , -- ���� (� ���������)
    IN inRouteId                 Integer   , -- �������
    IN inRetailId                Integer   , -- ����. ����
    IN inGoodsId                 Integer   , -- ���� ���������� �� ������� ����� ������ ��������������
    IN inDays                    Integer   , --  +/- ���-�� ����
 INOUT ioTimes                   TVarChar  , --  �����
    IN inCarInfoName             TVarChar  , --  ����������
    IN inCarComment              TVarChar  , -- ���������� � ��������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCarInfoId Integer;
   DECLARE vbTimes TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inGoodsId, 0) <> 0
     THEN
         RAISE EXCEPTION '������.� ������ ����������� �� ������� ��������� �� ��������.';
     END IF;

     -- ������
     IF TRIM (ioTimes) = '' THEN ioTimes:= '0'; END IF;

     -- ������
     vbTimes:= CASE WHEN STRPOS (REPLACE (REPLACE (REPLACE (ioTimes,'-' ,':'),'.' ,':'),',' ,':'), ':') > 0
                         THEN REPLACE (REPLACE (REPLACE (ioTimes,'-' ,':'),'.' ,':'),',' ,':')
                    ELSE ioTimes || ':00'
               END;

     --
     IF COALESCE (inRouteId, 0) = 0 AND COALESCE (inRetailId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� � �������� ���� �� �����������.';
     END IF;

     --
     IF STRPOS (vbTimes, ':') > 0
     THEN
         IF zfConvert_StringToTime ((inOperDatePartner + (inDays || ' Day') :: INTERVAL) :: Date ||' ' || vbTimes) = zc_DateStart()
         THEN
             RAISE EXCEPTION '������.�������� ������ ��� ������� : <%>', ioTimes;
         END IF;
     ELSE
         IF ioTimes <> '0' AND (zfConvert_StringToNumber (ioTimes) = 0 OR zfConvert_StringToNumber (ioTimes) > 23)
         THEN
             RAISE EXCEPTION '������.�������� ������ ��� ������� : <%>', ioTimes;
         END IF;
     END IF;



     --
     outOperDate_CarInfo := ((inOperDatePartner + (inDays || ' Day') :: INTERVAL) :: Date ||' ' || vbTimes) TDateTime;
     --
     outDayName:= (SELECT zfCalc.DayOfWeekName FROM zfCalc_DayOfWeekName (outOperDate_CarInfo) AS zfCalc);
     --
     ioTimes:= CASE WHEN zfConvert_TimeShortToString (outOperDate_CarInfo) = '00:00' THEN '' ELSE zfConvert_TimeShortToString (outOperDate_CarInfo) END;

     --RAISE EXCEPTION '<%>', outOperDate_CarInfo;

     -- ������� �����  CarInfoId
     vbCarInfoId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CarInfo() AND Object.ValueData = TRIM (inCarInfoName) AND Object.isErased = FALSE AND inCarInfoName <> '');
     IF COALESCE (vbCarInfoId,0) = 0 AND TRIM (inCarInfoName) <> ''
     THEN
         --���������
         vbCarInfoId := gpInsertUpdate_Object_CarInfo (ioId       := 0     ::Integer        -- ���� ������� <�������>
                                                     , inCode     := 0     ::Integer        -- ��� �������
                                                     , inName     := TRIM (inCarInfoName) ::TVarChar        -- �������� �������
                                                     , inSession  := inSession            ::TVarChar        -- ������ ������������
                                                      );
     END IF;

     --
     PERFORM lpInsert_MovementProtocol (tmp.MovementId, vbUserId, FALSE)
     FROM (-- 
           SELECT lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), tmp.MovementId, outOperDate_CarInfo)        -- ����/����� ��������
                , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarInfo(), tmp.MovementId, vbCarInfoId)    -- ���������� �� ��������
                , lpInsertUpdate_MovementString (zc_MovementString_CarComment(), tmp.MovementId, inCarComment)        -- ���������� � ��������
                , tmp.MovementId
           FROM (SELECT Movement.Id AS MovementId
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
                   AND (inRetailId = CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, Object_From.Id) END
                     OR COALESCE (inRetailId, 0) = 0
                       )
                   AND COALESCE (MovementLinkObject_Route.ObjectId, 0) = inRouteId
                   ) AS tmp
             ) AS tmp
             ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.22         *
 16.06.22         *
*/

-- ����
--