<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('cloture_incidents', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('cloture_account_id')->unsigned();
            $table->string('montant');
            $table->string('devise');
            $table->string('type_incident');
            $table->timestamps();
            $table->foreign('cloture_account_id')->references('id')->on('cloture_account')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('cloture_incidents');
    }
};
