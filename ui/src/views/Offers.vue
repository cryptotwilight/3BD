<template>
  <div class="py-4 container-fluid">
    <div class="row">
      <div class="col-12">
        <offers-table />
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <projects-table />
      </div>
    </div>
  </div>
</template>

<script>
import OffersTable from "./components/OffersTable.vue";
import ProjectsTable from "./components/ProjectsTable.vue";

export default {
  name: "OffersPage",
  components: {
    OffersTable,
    ProjectsTable,
  },
};
</script>
