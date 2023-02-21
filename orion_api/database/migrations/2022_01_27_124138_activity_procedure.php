<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class ActivityProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        $store_procedure = "
        DROP PROCEDURE IF EXISTS `newActivity`;
        CREATE PROCEDURE `newActivity`(
            IN `facture` VARCHAR(100),
            IN `transaction` VARCHAR(100)
            )
        NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER
            BEGIN
                SET @s1 = CONCAT('CREATE TABLE ', facture, ' ( `id` bigint(20) PRIMARY KEY AUTO_INCREMENT, `dateTrans` datetime, `type_operation` varchar(200), `type_devise` varchar(200),`amount` varchar(20), `quantity` varchar(20) DEFAULT 0, `status` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,`source` varchar(255) COLLATE utf8mb4_unicode_ci,`users_id` bigint(20) UNSIGNED,`created_at` datetime NOT null DEFAULT CURRENT_TIMESTAMP,`updated_at` datetime NOT Null DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)');
                SET @sa1 = CONCAT('ALTER TABLE ', facture, ' ADD FOREIGN KEY (`users_id`) REFERENCES users (`id`)' );
                PREPARE stm1 FROM @s1;
                PREPARE stma1 FROM @sa1;
                EXECUTE stm1;
                EXECUTE stma1;
                DEALLOCATE PREPARE stm1;
                DEALLOCATE PREPARE stma1;

                SET @s2 = CONCAT('CREATE TABLE ', transaction, ' ( `id` bigint(20) PRIMARY KEY AUTO_INCREMENT, `refkey` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL , `dateTrans` datetime,`type_operation` varchar(200), `type_payment` varchar(200), `client_number` varchar(20), `type_devise` varchar(200), `amount` varchar(20), `quantity` varchar(20) DEFAULT 0, `status` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,`source` varchar(255) COLLATE utf8mb4_unicode_ci,`account_id` bigint(20) UNSIGNED NOT NULL, `users_id` bigint(20) UNSIGNED NOT NULL,`created_at` datetime NOT null DEFAULT CURRENT_TIMESTAMP,`updated_at` datetime NOT Null DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)');
                SET @sa2 = CONCAT('ALTER TABLE ', transaction, ' ADD FOREIGN KEY (`users_id`) REFERENCES users (`id`)' );
                SET @sb2 = CONCAT('ALTER TABLE ', transaction, ' ADD FOREIGN KEY (`account_id`) REFERENCES accounts (`id`)' );
                PREPARE stm2 FROM @s2;
                PREPARE stma2 FROM @sa2;
                PREPARE stmb2 FROM @sa2;
                EXECUTE stm2;
                EXECUTE stma2;
                EXECUTE stmb2;
                DEALLOCATE PREPARE stm2;
                DEALLOCATE PREPARE stma2;
                DEALLOCATE PREPARE stmb2;
            END;
        ";

        DB::unprepared($store_procedure);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('store_procedure');
    }
}
