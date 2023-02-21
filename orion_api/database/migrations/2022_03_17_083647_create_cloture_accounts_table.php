<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateClotureAccountsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('cloture_accounts', function (Blueprint $table) {
            $table->id();
            $table->float('amount_usd')->default(0);
            $table->float('amount_cdf')->default(0);
            $table->bigInteger('sender_id')->unsigned();
            $table->bigInteger('receiver_id')->unsigned();
            $table->float('received_usd')->default(0);
            $table->float('received_cdf')->default(0);
            $table->string('status')->nullable();
            $table->dateTime('date_send');
            $table->dateTime('date_received')->nullable();
            $table->foreign('sender_id')->references('id')->on('accounts')->onDelete('cascade');
            $table->foreign('receiver_id')->references('id')->on('accounts')->onDelete('cascade');
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
        Schema::dropIfExists('cloture_accounts');
    }
}
