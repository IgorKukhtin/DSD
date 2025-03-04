-- Function: lpInsertUpdate_Movement_OrderExternal()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderExternal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ������ � �����������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� �������� ������ �� �����������
    IN inOperDateMark        TDateTime , -- ���� ����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
 INOUT ioChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inRouteSortingId      Integer   , -- ���������� ���������
    IN inPersonalId          Integer   , -- ��������� (����������)
    IN inPriceListId         Integer   , -- ����� ����
    IN inPartnerId           Integer   , -- ����������
    IN inIsPrintComment      Boolean   , -- �������� ���������� � ��������� ��������� (��/���)
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_CarInfo Integer;
   DECLARE vbRetailId Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) OR inOperDateMark <> DATE_TRUNC ('DAY', inOperDateMark)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;


     -- ������, �.�. ������ �������
     ioChangePercent:= COALESCE ((SELECT Object_PercentView.ChangePercent FROM Object_ContractCondition_PercentView AS Object_PercentView WHERE Object_PercentView.ContractId = inContractId AND inOperDate BETWEEN Object_PercentView.StartDate AND Object_PercentView.EndDate), 0);


     -- ���������� ���� �������
     vbAccessKeyId:= CASE WHEN inFromId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev()

                          ELSE zfGet_AccessKey_onUnit (inToId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal(), inUserId)
                     END;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderExternal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <���� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateMark(), ioId, inOperDateMark);
     -- ��������� �������� <���� �������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);

     -- !!!��������!!!
     IF /*vbIsInsert = TRUE AND*/ inToId = 8459 -- ����������� ��������
      -- AND inUserId = 5
     THEN
         --
         vbRetailId:= (SELECT CASE WHEN Object_Route.Id IS NULL AND ObjectLink_Juridical_Retail.ChildObjectId IS NULL
                                        THEN Object_From.Id
                                   WHEN Object_From.DescId = zc_Object_Unit()
                                        THEN Object_From.Id
                                   -- ��������
                                   WHEN Object_Route.ValueData ILIKE '������� �%'
                                     OR Object_Route.ValueData ILIKE '�����%'
                                     OR Object_Route.ValueData ILIKE '%-�������'
                                     OR Object_Route.ValueData ILIKE '%������ ���%'
                                        THEN 0
                                   ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
                              END
                       FROM MovementLinkObject AS MovementLinkObject_From
                            LEFT JOIN Object AS Object_From  ON Object_From.Id  = MovementLinkObject_From.ObjectId
                            LEFT JOIN Object AS Object_Route ON Object_Route.Id = inRouteId
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                       WHERE MovementLinkObject_From.MovementId = ioId
                         AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                      );

         -- �����
         vbMovementId_CarInfo:= (WITH tmpMovement AS (SELECT * FROM Movement
                                                      WHERE Movement.OperDate = inOperDate
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId   = zc_Movement_OrderExternal()
                                                     )
                                 --
                                 SELECT MIN (Movement.Id)
                                 FROM tmpMovement AS Movement
                                      -- ����� ����� ��
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                                   AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                   AND MovementLinkObject_To.ObjectId   = inToId
                                      -- ������� ����� ��
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                                   ON MovementLinkObject_Route.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
                                      -- ����������� ����
                                      INNER JOIN MovementDate AS MovementDate_CarInfo
                                                              ON MovementDate_CarInfo.MovementId = Movement.Id
                                                             AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                                                             AND (MovementDate_CarInfo.ValueData <> DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                                               OR EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) <> 0
                                                                 )
                                      -- ���� ����� ��
                                      INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                              ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                             AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                                             AND MovementDate_OperDatePartner.ValueData  = inOperDatePartner
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                                                   AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                                 WHERE Movement.Id <> ioId
                                   AND Movement.OperDate = inOperDate
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.DescId   = zc_Movement_OrderExternal()
                                   AND (((ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId OR COALESCE (vbRetailId, 0) = 0)
                                      AND(MovementLinkObject_Route.ObjectId         = inRouteId  OR COALESCE (inRouteId, 0)  = 0)
                                        )
                                     OR (MovementLinkObject_From.ObjectId = inFromId AND COALESCE (vbRetailId, 0) = 0 AND COALESCE (inRouteId, 0) = 0)
                                       )
                                );
         --
         IF inRouteId > 0 OR vbRetailId > 0
         THEN
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo()
                                                , ioId
                                                , COALESCE ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_CarInfo AND MD.DescId = zc_MovementDate_CarInfo())
                                                          , (SELECT -- !!!����/����� �������� - ������!!!
                                                                    (inOperDatePartner 
                                                                   + ((CASE WHEN ObjectFloat_Days.ValueData > 0 THEN  1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                                   - ((CASE WHEN ObjectFloat_Days.ValueData < 0 THEN -1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                                   + ((COALESCE (ObjectFloat_Hour.ValueData, 0) :: Integer) :: TVarChar || ' HOUR')   :: INTERVAL
                                                                   + ((COALESCE (ObjectFloat_Min.ValueData, 0)  :: Integer) :: TVarChar || ' MINUTE') :: INTERVAL
                                                                    ) :: TDateTime
                                                             FROM Object AS Object_OrderCarInfo
                                                                  LEFT JOIN ObjectLink AS ObjectLink_Route
                                                                                       ON ObjectLink_Route.ObjectId = Object_OrderCarInfo.Id
                                                                                      AND ObjectLink_Route.DescId   = zc_ObjectLink_OrderCarInfo_Route()
                                                                  LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                                                       ON ObjectLink_Retail.ObjectId = Object_OrderCarInfo.Id
                                                                                      AND ObjectLink_Retail.DescId   = zc_ObjectLink_OrderCarInfo_Retail()

                                                                  INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                                        ON ObjectLink_Unit.ObjectId      = Object_OrderCarInfo.Id
                                                                                       AND ObjectLink_Unit.DescId        = zc_ObjectLink_OrderCarInfo_Unit()
                                                                                       AND ObjectLink_Unit.ChildObjectId = inToId

                                                                  INNER JOIN ObjectFloat AS ObjectFloat_OperDate
                                                                                         ON ObjectFloat_OperDate.ObjectId  = Object_OrderCarInfo.Id
                                                                                        AND ObjectFloat_OperDate.DescId    = zc_ObjectFloat_OrderCarInfo_OperDate()
                                                                                        AND ObjectFloat_OperDate.ValueData =  zfCalc_DayOfWeekNumber (inOperDate)
                                                                  INNER JOIN ObjectFloat AS ObjectFloat_OperDatePartner
                                                                                         ON ObjectFloat_OperDatePartner.ObjectId  = Object_OrderCarInfo.Id
                                                                                        AND ObjectFloat_OperDatePartner.DescId    = zc_ObjectFloat_OrderCarInfo_OperDatePartner()
                                                                                        AND ObjectFloat_OperDatePartner.ValueData = zfCalc_DayOfWeekNumber (inOperDatePartner)

                                                                  LEFT JOIN ObjectFloat AS ObjectFloat_Days
                                                                                        ON ObjectFloat_Days.ObjectId = Object_OrderCarInfo.Id
                                                                                       AND ObjectFloat_Days.DescId = zc_ObjectFloat_OrderCarInfo_Days()
                                                                  LEFT JOIN ObjectFloat AS ObjectFloat_Hour
                                                                                        ON ObjectFloat_Hour.ObjectId = Object_OrderCarInfo.Id
                                                                                       AND ObjectFloat_Hour.DescId = zc_ObjectFloat_OrderCarInfo_Hour()
                                                                  LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                                                                        ON ObjectFloat_Min.ObjectId = Object_OrderCarInfo.Id
                                                                                       AND ObjectFloat_Min.DescId = zc_ObjectFloat_OrderCarInfo_Min()
                                                             WHERE Object_OrderCarInfo.DescId   = zc_Object_OrderCarInfo()
                                                               AND Object_OrderCarInfo.isErased = FALSE
                                                               AND COALESCE (ObjectLink_Route.ChildObjectId, 0)  = COALESCE (inRouteId, 0)
                                                               AND COALESCE (ObjectLink_Retail.ChildObjectId, 0) = COALESCE (vbRetailId, 0)
                                                             ORDER BY ObjectFloat_Hour.ValueData DESC
                                                             LIMIT 1
                                                            )
                                                          , CASE WHEN inOperDate = inOperDatePartner
                                                                      THEN inOperDate + INTERVAL '1 DAY' + INTERVAL '0 MIN'
                                                                 ELSE inOperDatePartner + INTERVAL '0 MIN'
                                                            END
                                                           )
                                                 );
             --
             IF inUserId = 5 AND 1=0
             THEN
                 RAISE EXCEPTION '������.%  %  %  %  %.', inRouteId , vbRetailId, vbMovementId_CarInfo
                                                        , (select MD.ValueData from MovementDate AS MD where MD.MovementId = vbMovementId_CarInfo and MD.DescId = zc_MovementDate_CarInfo())
                                                        , (select MD.ValueData from MovementDate AS MD where MD.MovementId = ioId and MD.DescId = zc_MovementDate_CarInfo())
                                                         ;
             END IF;

         ELSE
             --
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo()
                                                , ioId
                                                , CASE WHEN inOperDate = inOperDatePartner
                                                            THEN inOperDate + INTERVAL '1 DAY' + INTERVAL '0 MIN'
                                                       ELSE inOperDatePartner + INTERVAL '0 MIN'
                                                  END
                                                 );
             --
             IF inUserId = 5 AND 1=0
             THEN
                 RAISE EXCEPTION '������.err.';
             END IF;

         END IF;

     END IF;

     -- ��������� �������� <����� ������ � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <�������� ���������� � ��������� ���������(��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PrintComment(), ioId, inIsPrintComment);

     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, ioChangePercent);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);
     -- ��������� ����� � <���������� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);

     -- ��������� ����� � <��������� (����������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);

     -- ��������� ����� � <����� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);


     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.05.21         * add inIsPrintComment
 26.05.15         * add inPartnerId
 19.02.15         * add OperDateStart, OperDateEnd
 25.08.14                                        *
*/
/*
-- update Movement set AccessKeyId = AccessKeyId_new from (
select Object_to.*, Movement.Id, Movement.OperDate, Movement.InvNumber, Movement.AccessKeyId AS AccessKeyId_old
                   , CASE WHEN MovementLinkObject .ObjectId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev()
                          WHEN MovementLinkObject.ObjectId IN (346093 -- ����� �� �.������
                                                             , 346094 -- ����� ��������� �.������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa()
                          WHEN MovementLinkObject.ObjectId IN (8413 -- ����� �� �.������ ���
                                                             , 428366 -- ����� ��������� �.������ ���
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog()
                          WHEN MovementLinkObject .ObjectId= 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev()
                          WHEN MovementLinkObject.ObjectId IN (8425   -- ����� �� �.�������
                                                             , 409007 -- ����� ��������� �.�������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov()
                          WHEN MovementLinkObject .ObjectId= 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi()
                          WHEN MovementLinkObject .ObjectId= 301309 -- ����� �� �.���������
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye()
                          WHEN MovementLinkObject .ObjectId = 3080691 -- ����� �� �.�����
                               THEN zc_Enum_Process_AccessKey_DocumentLviv()
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END as AccessKeyId_new
from Movement
 left join     MovementLinkObject as mlo on mlo.DescId = zc_MovementLinkObject_from()
            and mlo.MovementId = Movement .Id
 left join     MovementLinkObject on MovementLinkObject.DescId = zc_MovementLinkObject_To()
            and MovementLinkObject .MovementId = Movement .Id
 left join     Object as Object_from on Object_from.Id = MLO.ObjectId
 left join     Object as Object_to on Object_to.Id = MovementLinkObject.ObjectId
 left join     Object as Object_a on Object_a.Id = Movement.AccessKeyId
where Movement.OperDate >= '01.12.2020'
and Movement.DescId = zc_Movement_OrderExternal()
and Object_from.DescId <> zc_Object_Unit()
-- and Movement.StatusId <> zc_Enum_Status_Erased()
and Movement.AccessKeyId <> CASE WHEN MovementLinkObject .ObjectId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev()
                          WHEN MovementLinkObject.ObjectId IN (346093 -- ����� �� �.������
                                                             , 346094 -- ����� ��������� �.������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa()
                          WHEN MovementLinkObject.ObjectId IN (8413 -- ����� �� �.������ ���
                                                             , 428366 -- ����� ��������� �.������ ���
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog()
                          WHEN MovementLinkObject .ObjectId= 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev()
                          WHEN MovementLinkObject.ObjectId IN (8425   -- ����� �� �.�������
                                                             , 409007 -- ����� ��������� �.�������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov()
                          WHEN MovementLinkObject .ObjectId= 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi()
                          WHEN MovementLinkObject .ObjectId= 301309 -- ����� �� �.���������
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye()
                          WHEN MovementLinkObject .ObjectId = 3080691 -- ����� �� �.�����
                               THEN zc_Enum_Process_AccessKey_DocumentLviv()
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END
limit 100
--) as tmp
--where Movement.Id = tmp.Id
*/
-- ����
-- SELECT * FROM lpInsertUpdate_Movement_OrderExternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
