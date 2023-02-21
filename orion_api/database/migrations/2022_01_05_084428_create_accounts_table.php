<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAccountsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('accounts', function (Blueprint $table) {
            $table->id();
            // $table->bigInteger('activities_id')->unsigned();
            $table->bigInteger('users_id')->unsigned()->unique();
            $table->bigInteger('created_users_id')->unsigned();
            $table->double('sold_cash_cdf');
            $table->double('sold_cash_usd');
            // $table->double('virtual_cash_cdf');
            // $table->double('virtual_cash_usd');
            $table->boolean('statusActive')->default(true);

            $table->bigInteger('branch_id')->unsigned();
            $table->foreign('branch_id')->references('id')->on('branches')->onDelete('cascade');
            // sold pret
            $table->double('sold_pret_cdf')->default(0);
            $table->double('sold_pret_usd')->default(0);

            // sold Emprunt
            $table->double('sold_emprunt_cdf')->default(0);
            $table->double('sold_emprunt_usd')->default(0);

            // foreign keys and their tables
            // $table->foreign('activities_id')->references('id')->on('activities')->onDelete('cascade');
            $table->foreign('users_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('created_users_id')->references('id')->on('users')->onDelete('cascade');

            // if ohada is connected to this app
            $table->bigInteger('sold_cash_cdf_compteId')->nullable();
            $table->bigInteger('sold_cash_usd_compteId')->nullable();
            // $table->bigInteger('virtual_cash_cdf_compteId')->nullable();
            // $table->bigInteger('virtual_cash_usd_compteId')->nullable();

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
        Schema::dropIfExists('accounts');
    }
}
