<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateDemandsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('demands', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('sender_id')->unsigned();
            $table->bigInteger('receiver_id')->unsigned();
            $table->double('amount');
            $table->double('amount_send')->nullable();
            $table->string('type_devise');
            $table->string('type_transaction');
            $table->string('status');
            $table->bigInteger('activity_id')->nullable()->unsigned();
            $table->string('alerte');
            $table->foreign('sender_id')->references('id')->on('accounts')->onDelete('cascade');
            $table->foreign('receiver_id')->references('id')->on('accounts')->onDelete('cascade');
            $table->foreign('activity_id')->references('id')->on('activities')->onDelete('cascade');
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
        Schema::dropIfExists('demands');
    }
}
