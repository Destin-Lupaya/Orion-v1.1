<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTransacrtionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('transacrtions', function (Blueprint $table) {
            $table->id();
            $table->string('sender');
            $table->string('receiver');
            $table->string('refkey')->unique();
            $table->string('amount');
            $table->string('quantity');
            $table->dateTime('dateTrans');
            $table->string('type_operation');
            $table->string('type_devise');
            $table->string('type_transaction');
            $table->string('type_payment');
            $table->string('client_number');
            $table->bigInteger('account_id')->unsigned();
            $table->bigInteger('account_activity_id')->unsigned()->nullable();
            $table->bigInteger('demands_id')->unsigned()->nullable();
            $table->bigInteger('users_id')->unsigned();
            $table->foreign('account_id')->references('id')->on('accounts')->onDelete('cascade');
            $table->foreign('account_activity_id')->references('id')->on('account_activities')->onDelete('cascade');
            $table->foreign('demands_id')->references('id')->on('demands')->onDelete('cascade');
            $table->foreign('users_id')->references('id')->on('users')->onDelete('cascade');
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
        Schema::dropIfExists('transacrtions');
    }
}
