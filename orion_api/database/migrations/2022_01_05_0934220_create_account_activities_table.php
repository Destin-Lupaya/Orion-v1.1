<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAccountActivitiesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('account_activities', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('activity_id')->unsigned();
            $table->bigInteger('account_id')->unsigned();
            $table->double('virtual_cdf');
            $table->double('virtual_usd');
            $table->double('stock')->nullable()->default(0);
            $table->double('pret_cdf')->default(0);
            $table->double('pret_usd')->default(0);
            $table->double('emprunt_cdf')->default(0);
            $table->double('emprunt_usd')->default(0);
            $table->double('bonus_usd')->default(0);
            $table->double('bonus_cdf')->default(0);
            $table->double('percentage')->default(0);
            $table->foreign('activity_id')->references('id')->on('activities')->onDelete('cascade');
            $table->foreign('account_id')->references('id')->on('accounts')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('account_activities');
    }
    
}
