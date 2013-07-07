CREATE OR REPLACE FUNCTION zc_objectBlob_form_data()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_objectBlob_form_data()
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_objectBlob_UserFormSettings_Data()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 2;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_objectBlob_UserFormSettings_Data()
  OWNER TO postgres;


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ÕŒ¬¿ﬂ —’≈Ã¿ !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
/*CREATE OR REPLACE FUNCTION zc_objectBlob_form_data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_form_data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zc_objectBlob_form_data() OWNER TO postgres;

CREATE OR REPLACE FUNCTION zc_objectBlob_UserFormSettings_Data() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBlobDesc WHERE Code = 'zc_objectBlob_UserFormSettings_Data'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zc_objectBlob_UserFormSettings_Data() OWNER TO postgres;
*/
/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 07.07.13         * ÕŒ¬¿ﬂ —’≈Ã¿              
 28.06.13                                        * ÕŒ¬¿ﬂ —’≈Ã¿
*/
