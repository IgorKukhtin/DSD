CREATE OR REPLACE FUNCTION lpInsert_movement_wms_scale_header (
	IN inMovementId		Integer,  -- Ключ объекта <Документ>
	IN inSession    	TVarChar  -- сессия пользователя
)
RETURNS TABLE (Id Integer)
AS			  
$BODY$
   DECLARE vbPaidkindid Integer;
   DECLARE vbContractid Integer;
   DECLARE vbFromid Integer;
   DECLARE vbToid Integer;
BEGIN 

	SELECT 
		  fromid
		, toid
		, paidkindid
		, contractid 
	INTO
		  vbFromid
		, vbToid
		, vbPaidkindid
		, vbContractid  
	FROM  gpGet_Movement_OrderExternal (inMovementId := inMovementId
									  , inOperDate   := CURRENT_TIMESTAMP
									  , inSession    := inSession
									  );
	RETURN QUERY
		SELECT tmp.Id 
		FROM   gpinsertupdate_scale_movement (inid                 := 0
		                                    , inOperDate           := CURRENT_TIMESTAMP
										    , inmovementdescid     := 0
										    , inmovementdescnumber := 0
										    , infromid             := vbFromid
										    , intoid               := vbToid
										    , incontractid         := vbContractid
										    , inpaidkindid         := vbPaidkindid
										    , inpricelistid        := 0
										    , inmovementid_order   := inMovementId
										    , inchangepercent      := 0
										    , inbranchcode         := 0
										    , inSession            := inSession
										    ) AS tmp;

END; 
$BODY$
 LANGUAGE PLPGSQL VOLATILE;