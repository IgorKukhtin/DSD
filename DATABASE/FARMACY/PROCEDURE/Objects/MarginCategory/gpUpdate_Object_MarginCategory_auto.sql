-- Function: gpUpdate_Object_MarginCategory_auto()

DROP FUNCTION IF EXISTS gpUpdate_Object_MarginCategory_auto (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           , Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat
                                                           , Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat
                                                           , Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat
                                                           , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean
                                                           , TVarChar                                                           
                                                           );


CREATE OR REPLACE FUNCTION gpUpdate_Object_MarginCategory_auto(

    IN inMarginCategoryId Integer,       --

    IN inId_1           Integer,       -- MarginCategoryItem 0-15
    IN inId_2           Integer,       --
    IN inId_3           Integer,       --
    IN inId_4           Integer,       --
    IN inId_5           Integer,       --
    IN inId_6           Integer,       --
    IN inId_7           Integer,       --

    IN inMinPrice_1       Tfloat,       -- MarginCategoryItem 0-15
    IN inMinPrice_2       Tfloat,       --
    IN inMinPrice_3       Tfloat,       --
    IN inMinPrice_4       Tfloat,       --
    IN inMinPrice_5       Tfloat,       --
    IN inMinPrice_6       Tfloat,       --
    IN inMinPrice_7       Tfloat,       --

    IN inValue_1        Tfloat,       -- MarginCategoryItem 0-15
    IN inValue_2        Tfloat,       --
    IN inValue_3        Tfloat,       --
    IN inValue_4        Tfloat,       --
    IN inValue_5        Tfloat,       --
    IN inValue_6        Tfloat,       --
    IN inValue_7        Tfloat,       --

    IN inVal_1          Tfloat,       -- MarginCategoryItem 0-15
    IN inVal_2          Tfloat,       --
    IN inVal_3          Tfloat,       --
    IN inVal_4          Tfloat,       --
    IN inVal_5          Tfloat,       --
    IN inVal_6          Tfloat,       --
    IN inVal_7          Tfloat,       --

    IN inisVal_1        Boolean,       -- MarginCategoryItem 0-15
    IN inisVal_2        Boolean,       --
    IN inisVal_3        Boolean,       --
    IN inisVal_4        Boolean,       --
    IN inisVal_5        Boolean,       --
    IN inisVal_6        Boolean,       --
    IN inisVal_7        Boolean,       --

    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE UserId Integer;
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   UserId := inSession;

   IF inisVal_1 = TRUE
   THEN
    --RAISE EXCEPTION 'inisVal_1';
       PERFORM gpInsertUpdate_Object_MarginCategoryItem(ioId               := inId_1
                                                      , inMarginCategoryId := inMarginCategoryId
                                                      , inMinPrice         := inMinPrice_1 ::TFloat 
                                                      , inMarginPercent    := (COALESCE (inValue_1,0) + COALESCE (inVal_1,0)) ::TFloat 
                                                      , inSession          := inSession    ::TVarChar
                                                      );
   END IF;
      
   IF inisVal_2 = TRUE
   THEN
   --RAISE EXCEPTION 'inisVal_2';
       PERFORM gpInsertUpdate_Object_MarginCategoryItem(ioId               := inId_2
                                                      , inMarginCategoryId := inMarginCategoryId
                                                      , inMinPrice         := inMinPrice_2 ::TFloat 
                                                      , inMarginPercent    := (COALESCE (inValue_2,0) + COALESCE (inVal_2,0)) ::TFloat 
                                                      , inSession          := inSession    ::TVarChar
                                                      );
   END IF;

   IF inisVal_3 = TRUE
   THEN
       PERFORM gpInsertUpdate_Object_MarginCategoryItem(ioId               := inId_3
                                                      , inMarginCategoryId := inMarginCategoryId
                                                      , inMinPrice         := inMinPrice_3 ::TFloat 
                                                      , inMarginPercent    := (COALESCE (inValue_3,0) + COALESCE (inVal_3,0)) ::TFloat 
                                                      , inSession          := inSession    ::TVarChar
                                                      );
   END IF;

   IF inisVal_4 = TRUE
   THEN
       PERFORM gpInsertUpdate_Object_MarginCategoryItem(ioId               := inId_4
                                                      , inMarginCategoryId := inMarginCategoryId
                                                      , inMinPrice         := inMinPrice_4 ::TFloat 
                                                      , inMarginPercent    := (COALESCE (inValue_4,0) + COALESCE (inVal_4,0)) ::TFloat 
                                                      , inSession          := inSession    ::TVarChar
                                                      );
   END IF;

   IF inisVal_5 = TRUE
   THEN
       PERFORM gpInsertUpdate_Object_MarginCategoryItem(ioId               := inId_5
                                                      , inMarginCategoryId := inMarginCategoryId
                                                      , inMinPrice         := inMinPrice_5 ::TFloat 
                                                      , inMarginPercent    := (COALESCE (inValue_5,0) + COALESCE (inVal_5,0)) ::TFloat 
                                                      , inSession          := inSession    ::TVarChar
                                                      );
   END IF;

   IF inisVal_6 = TRUE
   THEN
       PERFORM gpInsertUpdate_Object_MarginCategoryItem(ioId               := inId_6
                                                      , inMarginCategoryId := inMarginCategoryId
                                                      , inMinPrice         := inMinPrice_6 ::TFloat 
                                                      , inMarginPercent    := (COALESCE (inValue_6,0) + COALESCE (inVal_6,0)) ::TFloat 
                                                      , inSession          := inSession    ::TVarChar
                                                      );
   END IF;

   IF inisVal_7 = TRUE
   THEN
       PERFORM gpInsertUpdate_Object_MarginCategoryItem(ioId               := inId_7
                                                      , inMarginCategoryId := inMarginCategoryId
                                                      , inMinPrice         := inMinPrice_7 ::TFloat 
                                                      , inMarginPercent    := (COALESCE (inValue_7,0) + COALESCE (inVal_7,0)) ::TFloat 
                                                      , inSession          := inSession    ::TVarChar
                                                      );
   END IF;


END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.19         *
*/

-- тест

/*
select * from gpUpdate_Object_MarginCategory_auto(inMarginCategoryId := 11408145 
, inId_1 := 11408147 , inId_2 := 11408148 , inId_3 := 11408149 , inId_4 := 11408150 , inId_5 := 11408151 , inId_6 := 11408152 , inId_7 := 11408153 
, inminPrice_1 := 0 ::Tfloat, inminPrice_2 := 15 ::Tfloat, inminPrice_3 := 50 ::Tfloat, inminPrice_4 := 100::Tfloat , inminPrice_5 := 200::Tfloat , inminPrice_6 := 300 ::Tfloat, inminPrice_7 := 1000 ::Tfloat
, inValue_1 := '19.5'::Tfloat , inValue_2 := '19.5'::Tfloat , inValue_3 := '19.5'::Tfloat , inValue_4 := '18.5'::Tfloat , inValue_5 := '18.5'::Tfloat, inValue_6 := '15.5'::Tfloat , inValue_7 := '10.5' ::Tfloat
, inVal_1 := 8 ::Tfloat, inVal_2 := 0 ::Tfloat, inVal_3 := 0 ::Tfloat, inVal_4 := 0 ::Tfloat, inVal_5 := 0 ::Tfloat, inVal_6 := 0 ::Tfloat, inVal_7 := 0::Tfloat 
, inisVal_1 := False ::Boolean, inisVal_2 := False::Boolean , inisVal_3 := False ::Boolean, inisVal_4 := False ::Boolean, inisVal_5 := False::Boolean , inisVal_6 := False ::Boolean, inisVal_7 :=False ::Boolean ,  inSession := '3');
*/