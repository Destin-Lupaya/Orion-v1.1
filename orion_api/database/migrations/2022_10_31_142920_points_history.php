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
        Schema::create('points_histories', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('activity_id')->unsigned();
            $table->string('client_number');
            $table->string('montant_transaction');
            $table->text('points');
            $table->string('type_operation')->default('octroi');
            $table->timestamps();
            $table->foreign('activity_id')->references('id')->on('activities')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('points_history');
    }
};
